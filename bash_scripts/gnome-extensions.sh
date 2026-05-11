#!/usr/bin/env bash

# Install gext (gnome-extensions-cli) via pipx
if type -p "gext" > /dev/null; then
    echo "gext already installed" >> "$LOG_FILE"
else
    pipx install gnome-extensions-cli --system-site-packages

    if type -p "gext" > /dev/null; then
        echo "gext Installed via pipx" >> "$LOG_FILE"
    else
        echo "gext FAILED TO INSTALL!!!" >> "$LOG_FILE"
    fi
fi

# Install extensions
gext install just-perfection-desktop@just-perfection
gext install space-bar@luchrioh  
gext install switcher@landau.fi
gext install tactile@lundal.io
gext install tiling-assistant@leleat-on-github

# Load config of extensions
dconf load /org/gnome/shell/extensions/ < gnome-extensions/extensions_config.txt

# Comp;ie schemas
for ext in ~/.local/share/gnome-shell/extensions/*/; do
    if [ -d "$ext/schemas" ]; then
        echo "Compiling schemas for: $(basename "$ext")"
        glib-compile-schemas "$ext/schemas/"
    fi
done
