#!/usr/bin/env bash
# Installation of additional packages, that make life easier

source .exports

# Create directory for packages if it doesn't exist
mkdir -p $PATH_TO_ADDITIONAL_PACKAGES 
echo "Installation Log for date: $(date)" > $LOG_FILE

# ----------------------
# Git installation 
# ----------------------

# autojump
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

# fuzzy finder
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

# vim-plug - plugin manager
if [[ -f ~/.vim/autoload/plug.vim ]]; then
    echo "Vim-Plug already installed" >> $LOG_FILE
else
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    if [[ -f ~/.vim/autoload/plug.vim ]]; then
        echo "Vim-Plug Installed" >> $LOG_FILE
    else
        echo "Vim-Plug FAILED TO INSTALL!!!" >> $LOG_FILE
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
