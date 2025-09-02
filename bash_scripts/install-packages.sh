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

if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tmux_plugin_manager" ]; then
    echo "tpm already installed" >> $LOG_FILE
else
    git clone https://github.com/tmux-plugins/tpm $PATH_TO_ADDITIONAL_PACKAGES/tmux_plugin_manager

    if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tmux_plugin_manager" ]; then
        echo "tmux_plugin_manager Installed" >> $LOG_FILE
    else
        echo "tmux_plugin_manager FAILED TO INSTALL!!!" >> $LOG_FILE
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
# Meld installation
# ----------------------

if type -p meld > /dev/null; then
    echo "meld already installed" >> $LOG_FILE
else
    sudo apt-get update && sudo apt-get install -y meld

    if type -p meld > /dev/null; then
        echo "meld Installed" >> $LOG_FILE
    else
        echo "meld FAILED TO INSTALL!!!" >> $LOG_FILE
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

# ----------------------
# fd-find installation
# ----------------------

if type -p fd > /dev/null || type -p fdfind > /dev/null; then
    echo "fd-find already installed" >> $LOG_FILE
else
    sudo apt update
    sudo apt install -y fd-find

    # Check installation
    if type -p fd > /dev/null || type -p fdfind > /dev/null; then
        echo "fd-find Installed" >> $LOG_FILE
    else
        echo "fd-find FAILED TO INSTALL!!!" >> $LOG_FILE
    fi
fi

# ----------------------
# Virtualenvwrapper installation
# ----------------------

if python3 -c "import virtualenvwrapper" 2>/dev/null; then
    echo "virtualenvwrapper already installed" >> $LOG_FILE
else
    # Install virtualenvwrapper using apt
    sudo apt-get install -y virtualenvwrapper
    
    # Verify installation
    if python3 -c "import virtualenvwrapper" 2>/dev/null; then
        echo "virtualenvwrapper Installed" >> $LOG_FILE
    else
        # Create a virtual environment first
        python3 -m venv ~/.py_global_env
        
        # Activate and install virtualenvwrapper in it
        source ~/.py_global_env/bin/activate
        pip install virtualenvwrapper
        
        if python3 -c "import virtualenvwrapper" 2>/dev/null; then
            echo "virtualenvwrapper Installed via fallback method" >> $LOG_FILE
        else
            echo "virtualenvwrapper FAILED TO INSTALL VIA FALLBACK METHOD!!!" >> $LOG_FILE
        fi
    fi
fi

# ----------------------
# Yazi installation
# ----------------------

if type -p yazi > /dev/null; then
    echo "yazi already installed" >> "$LOG_FILE"
else
    # Try snap first
    if type -p snap > /dev/null; then
        echo "installing yazi via snap" >> "$LOG_FILE"
        sudo snap install yazi --classic

    # Fallback to cargo (requires Rust toolchain)
    elif type -p cargo > /dev/null; then
        echo "installing yazi via cargo" >> "$LOG_FILE"
        cargo install yazi-fm
        mkdir -p ~/.local/bin
        ln -sf ~/.cargo/bin/yazi ~/.local/bin/yazi

    else
        echo "no installer found for yazi (need snap or cargo)" >> "$LOG_FILE"
    fi

    # Confirm install
    if type -p yazi > /dev/null; then
        echo "yazi Installed" >> "$LOG_FILE"
    else
        echo "yazi FAILED TO INSTALL!!!" >> "$LOG_FILE"
    fi
fi

# ----------------------
# LSD installation
# ----------------------

if type -p lsd > /dev/null; then
    echo "lsd already installed" >> "$LOG_FILE"
else
    # Try apt (Ubuntu 24.04 has lsd in universe)
    if type -p apt > /dev/null; then
        echo "installing lsd via apt" >> "$LOG_FILE"
        sudo apt update
        sudo apt install -y lsd

    # Fallback to snap
    elif type -p snap > /dev/null; then
        echo "installing lsd via snap" >> "$LOG_FILE"
        sudo snap install lsd --classic

    # Fallback to cargo
    elif type -p cargo > /dev/null; then
        echo "installing lsd via cargo" >> "$LOG_FILE"
        cargo install lsd
        mkdir -p ~/.local/bin
        ln -sf ~/.cargo/bin/lsd ~/.local/bin/lsd

    else
        echo "no installer found for lsd (need apt, snap, or cargo)" >> "$LOG_FILE"
    fi

    # Confirm install
    if type -p lsd > /dev/null; then
        echo "lsd Installed" >> "$LOG_FILE"
    else
        echo "lsd FAILED TO INSTALL!!!" >> "$LOG_FILE"
    fi
fi
