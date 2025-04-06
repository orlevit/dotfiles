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

if type -p "batcat" > /dev/null; then
    echo "bat is already installed" >> $LOG_FILE
else
    sudo apt update && sudo apt install -y bat

    if type -p "batcat" > /dev/null; then
        echo "bat installed successfully" >> $LOG_FILE
    else
        echo "bat installation FAILED!!!" >> $LOG_FILE
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

# ----------------------
# Tree installation
# ----------------------

if type -p tree > /dev/null; then
    echo "tree already installed" >> $LOG_FILE
else
    sudo apt-get update && sudo apt-get install -y tree

    if type -p tree > /dev/null; then
        echo "tree Installed" >> $LOG_FILE
    else
        echo "tree FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi

# ----------------------
# Kitty installation
# ----------------------

if type -p kitty > /dev/null; then
    echo "kitty already installed" >> $LOG_FILE
else
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    # Add symlink
    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/bin/kitty

    # Confirm install
    if type -p kitty > /dev/null; then
        echo "kitty Installed" >> $LOG_FILE
    else
        echo "kitty FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi
