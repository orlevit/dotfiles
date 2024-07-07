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

# Add vim-surround to .vimrc and install plugins
VIMRC=~/.vimrc

if ! grep -q "Plug 'tpope/vim-surround'" "$VIMRC"; then
    # Add vim-plug block if not present
    if ! grep -q "call plug#begin('~/.vim/plugged')" "$VIMRC"; then
        echo "Adding vim-plug configuration to $VIMRC"
        echo "
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-surround'
call plug#end()
" >> "$VIMRC"
    else
        echo "Adding vim-surround to existing plug configuration in $VIMRC"
        sed -i "/call plug#begin('~\/.vim\/plugged')/a\Plug 'tpope/vim-surround'" "$VIMRC"
    fi

    # Install plugins
    vim +PlugInstall +qall
    echo "vim-surround installed" >> $LOG_FILE
else
    echo "vim-surround already configured in $VIMRC" >> $LOG_FILE
fi
