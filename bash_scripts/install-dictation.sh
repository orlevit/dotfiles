#!/usr/bin/env bash

source .exports

DICTATION_DIR="$PWD/dictation"
NERD_DICTATION_DIR="$HOME/nerd-dictation"

echo "$PROMPT Installing dictation setup..." >> $LOG_FILE

# 1. System packages
for pkg in wtype ydotool parec; do
    bin=$pkg
    [ "$pkg" = "parec" ] && bin="parec"
    if type -p "$bin" > /dev/null 2>&1; then
        echo "$PROMPT $pkg already installed" >> $LOG_FILE
    else
        sudo apt-get install -y "$( [ "$pkg" = "parec" ] && echo pulseaudio-utils || echo "$pkg" )"
        if type -p "$bin" > /dev/null 2>&1; then
            echo "$PROMPT $pkg installed" >> $LOG_FILE
        else
            echo "$PROMPT $pkg FAILED!!!" >> $LOG_FILE
        fi
    fi
done

# 2. Input group + udev rule + uinput module
if [ -f /etc/udev/rules.d/60-uinput.rules ]; then
    echo "$PROMPT udev uinput rule already exists" >> $LOG_FILE
else
    echo 'KERNEL=="uinput", GROUP="input", MODE="0660"' | sudo tee /etc/udev/rules.d/60-uinput.rules > /dev/null
    echo uinput | sudo tee /etc/modules-load.d/uinput.conf > /dev/null
    sudo udevadm control --reload-rules && sudo udevadm trigger /dev/uinput
    echo "$PROMPT udev uinput rule created" >> $LOG_FILE
fi

if groups | grep -q input; then
    echo "$PROMPT user already in input group" >> $LOG_FILE
else
    sudo usermod -a -G input "$USER"
    echo "$PROMPT user added to input group (logout/login required)" >> $LOG_FILE
fi

# 3. Clone nerd-dictation
if [ -d "$NERD_DICTATION_DIR" ]; then
    echo "$PROMPT nerd-dictation already cloned" >> $LOG_FILE
else
    git clone https://github.com/ideasman42/nerd-dictation.git "$NERD_DICTATION_DIR"
    if [ -d "$NERD_DICTATION_DIR" ]; then
        echo "$PROMPT nerd-dictation cloned" >> $LOG_FILE
    else
        echo "$PROMPT nerd-dictation clone FAILED!!!" >> $LOG_FILE
    fi
fi

# 4. Python venv + packages
if [ -d "$NERD_DICTATION_DIR/venv" ]; then
    echo "$PROMPT dictation venv already exists" >> $LOG_FILE
else
    python3 -m venv "$NERD_DICTATION_DIR/venv"
    "$NERD_DICTATION_DIR/venv/bin/pip" install faster-whisper sounddevice >> $LOG_FILE 2>&1
    echo "$PROMPT dictation venv created" >> $LOG_FILE
fi

# 5. Pre-download Whisper model
MODEL_CACHE="$HOME/.cache/huggingface/hub/models--Systran--faster-whisper-small.en"
if [ -d "$MODEL_CACHE" ]; then
    echo "$PROMPT Whisper small.en model already cached" >> $LOG_FILE
else
    echo "$PROMPT Downloading Whisper small.en model (~466MB)..." >> $LOG_FILE
    "$NERD_DICTATION_DIR/venv/bin/python3" -c \
        "from faster_whisper import WhisperModel; WhisperModel('small.en', device='cpu', compute_type='int8')" \
        >> $LOG_FILE 2>&1
    echo "$PROMPT Whisper model downloaded" >> $LOG_FILE
fi

# 6. Symlink scripts
ln -sf "$DICTATION_DIR/whisper-dictation.py" "$NERD_DICTATION_DIR/whisper-dictation.py"
ln -sf "$DICTATION_DIR/toggle.sh" "$NERD_DICTATION_DIR/toggle.sh"
chmod +x "$NERD_DICTATION_DIR/toggle.sh"
echo "$PROMPT dictation scripts symlinked" >> $LOG_FILE

# 7. GNOME shortcut Super+R -> toggle.sh
BINDING_BASE="/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings"
BINDING_PATH="${BINDING_BASE}/custom-dictation/"

dconf write "${BINDING_PATH}name"    "'Dictation Toggle'"
dconf write "${BINDING_PATH}command" "'$HOME/nerd-dictation/toggle.sh'"
dconf write "${BINDING_PATH}binding" "'<Super>r'"

# Append to keybindings list without overwriting existing entries
EXISTING=$(dconf read "${BINDING_BASE}" 2>/dev/null)
DICTATION_ENTRY="'${BINDING_PATH}'"
if [[ "$EXISTING" != *"custom-dictation"* ]]; then
    if [ -z "$EXISTING" ] || [ "$EXISTING" = "@as []" ]; then
        dconf write "${BINDING_BASE}" "[$DICTATION_ENTRY]"
    else
        NEW_LIST="${EXISTING%]}, $DICTATION_ENTRY]"
        dconf write "${BINDING_BASE}" "$NEW_LIST"
    fi
    echo "$PROMPT GNOME shortcut Super+R registered" >> $LOG_FILE
else
    echo "$PROMPT GNOME shortcut already registered" >> $LOG_FILE
fi

echo ""
echo "$PROMPT Dictation setup complete."
echo "$PROMPT NOTE: Log out and back in for the 'input' group to take effect."
