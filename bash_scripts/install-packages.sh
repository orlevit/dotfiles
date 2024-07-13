#!/usr/bin/env bash
# Installation of additional packages, that make life easier

source .exports

# Create directory for packages if it doesn't exist
mkdir -p $PATH_TO_ADDITIONAL_PACKAGES 
echo "Installation Log for date: $(date)" > $LOG_FILE

# ----------------------
# Autojump installation 
# ----------------------

if type -p autojump > /dev/null; then
    echo "autojump already installed" >> $LOG_FILE
else
    git clone git://github.com/wting/autojump.git $PATH_TO_ADDITIONAL_PACKAGES/autojump
    cd $PATH_TO_ADDITIONAL_PACKAGES/autojump && ./install.py 

    if type -p autojump > /dev/null; then
        echo "autojump Installed" >> $LOG_FILE
    else
        echo "autojump FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
    cd -
fi

# ----------------------
# fuzzy finder
# ----------------------

if type -p "fzf" > /dev/null; then
    echo "fuzzy finder already installed" >> $LOG_FILE
else
    git clone --depth 1 https://github.com/junegunn/fzf.git $PATH_TO_ADDITIONAL_PACKAGES/fzf
    $PATH_TO_ADDITIONAL_PACKAGES/fzf/install

    if type -p "fzf" > /dev/null; then
        echo "fuzzy finder Installed" >> $LOG_FILE
    else
        echo "fuzzy finder FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi

# ----------------------
# fzf-git.sh installation 
# ----------------------

if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/fzf-git.sh" ]; then
    echo "fzf-git.sh already installed" >> $LOG_FILE
else
    git clone https://github.com/junegunn/fzf-git.sh.git $PATH_TO_ADDITIONAL_PACKAGES/fzf-git.sh
    if [ $? -eq 0 ]; then
        echo "fzf-git.sh Installed" >> $LOG_FILE
        ln -svf "$PATH_TO_ADDITIONAL_PACKAGES/fzf-git.sh" "$HOME/fzf-git.sh" 
    else
        echo "fzf-git.sh FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi

# ----------------------
# bat installation
# ----------------------

# Check if bat is already installed
if type -p bat > /dev/null; then
    echo "bat already installed" >> "$LOG_FILE"
else
    # Determine the OS architecture
    ARCH=$(uname -m)

    # Define the latest version to install
    BAT_VERSION="0.23.0"

    # Determine the appropriate URL for the architecture
    case "$ARCH" in
        x86_64)
            BAT_URL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-x86_64-unknown-linux-gnu.tar.gz"
            ;;
        aarch64)
            BAT_URL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-aarch64-unknown-linux-gnu.tar.gz"
            ;;
        arm*)
            BAT_URL="https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat-v$BAT_VERSION-arm-unknown-linux-gnueabihf.tar.gz"
            ;;
        *)
            echo "Unsupported architecture: $ARCH" >> "$LOG_FILE"
            exit 1
            ;;
    esac

    # Create a directory for the bat package
    mkdir -p "$PATH_TO_ADDITIONAL_PACKAGES/bat"

    # Download and install bat
    wget -O "$PATH_TO_ADDITIONAL_PACKAGES/bat/bat.tar.gz" "$BAT_URL"
    tar -xzf "$PATH_TO_ADDITIONAL_PACKAGES/bat/bat.tar.gz" -C "$PATH_TO_ADDITIONAL_PACKAGES/bat"
    sudo mv "$PATH_TO_ADDITIONAL_PACKAGES/bat/bat-v$BAT_VERSION-*/bat" /usr/local/bin/

    # Clean up
    rm -rf "$PATH_TO_ADDITIONAL_PACKAGES/bat"

    if type -p bat > /dev/null; then
        echo "bat Installed" >> "$LOG_FILE"
    else
        echo "bat FAILED TO INSTALL!!!" >> "$LOG_FILE"
    fi
fi

# ----------------------
# ripgrep installation
# ----------------------

if type -p "rg" > /dev/null; then
    echo "ripgrep already installed" >> $LOG_FILE
else
    sudo apt update
    sudo apt install -y ripgrep

    if type -p "rg" > /dev/null; then
        echo "ripgrep Installed via apt" >> $LOG_FILE
    else
        echo "ripgrep FAILED TO INSTALL via apt!!!" >> $LOG_FILE
    fi
fi

# --------------------------------------------
# tpm (Tmux Plugin Manager) installation
# --------------------------------------------

if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tpm" ]; then
    echo "tpm already installed" >> $LOG_FILE
else
    git clone https://github.com/tmux-plugins/tpm $PATH_TO_ADDITIONAL_PACKAGES/tpm

    if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tpm" ]; then
        echo "tpm Installed" >> $LOG_FILE
    else
        echo "tpm FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi

# --------------------------------------------
# git-delta installation
# --------------------------------------------

if type -p delta > /dev/null; then
    echo "git-delta already installed" >> $LOG_FILE
else
    sudo apt-get install -y git-delta

    if type -p delta > /dev/null; then
        echo "git-delta Installed" >> $LOG_FILE
    else
        echo "git-delta FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi


# --------------------------------------------
# tldr installation
# --------------------------------------------

if type -p tldr > /dev/null; then
    echo "git-delta already installed" >> $LOG_FILE
else
    sudo apt install tldr

    if type -p tldr > /dev/null; then
        echo "tldr Installed" >> $LOG_FILE
    else
        echo "tldr FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi


