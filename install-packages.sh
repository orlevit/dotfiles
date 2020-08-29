#!/user/bin/env bash
# Installation of additional packages, that make life easier 

source .exports

# Create directory for packages if it doesn't exists
mkdir -p PATH_TO_ADDITIONAL_PACKAGES 
cd PATH_TO_ADDITIONAL_PACKAGES

# ----------------------
# Git installation 
# ----------------------

# autojump
git clone git://github.com/wting/autojump.git
cd autojump && . install.py 

if type -p  autojump > /dev/null; then
    echo "autojump Installed" >> $LOG_FILE
else
    echo "autojump FAILED TO INSTALL!!!" >> $LOG_FILE
fi

# fuzzy finder
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

if type -p "fzf" > /dev/null; then
    echo "fuzzy finder Installed" >> $LOG_FILE
else
    echo "fuzzy finder FAILED TO INSTALL!!!" >> $LOG_FILE
fi

