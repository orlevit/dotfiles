#!/usr/bin/env bash

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
