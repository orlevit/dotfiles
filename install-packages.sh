#!/user/bin/env bash
# Installation of additional packages, that make life easier 

source .exports

# Create directory for packages if it doesn't exists
mkdir -p $PATH_TO_ADDITIONAL_PACKAGES 
echo "Installation Log for date: $(date)" > $LOG_FILE
# ----------------------
# Git installation 
# ----------------------

# autojump
if type -p  autojump > /dev/null; then
	echo "autojump already installed" >> $LOG_FILE
else
	git clone git://github.com/wting/autojump.git $PATH_TO_ADDITIONAL_PACKAGES
	cd autojump && . install.py 

	if type -p  autojump > /dev/null; then
	    echo "autojump Installed" >> $LOG_FILE
	else
	    echo "autojump FAILED TO INSTALL!!!" >> $LOG_FILE
	fi
fi

# fuzzy finder
if type -p "fzf" > /dev/null; then
	echo "fuzzy finder already installed" >> $LOG_FILE
else
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf $PATH_TO_ADDITIONAL_PACKAGES
	~/.fzf/install

	if type -p "fzf" > /dev/null; then
	    echo "fuzzy finder Installed" >> $LOG_FILE
	else
	    echo "fuzzy finder FAILED TO INSTALL!!!" >> $LOG_FILE
	fi
fi

# vim plug-ins
# Vundle - package manager
if [[ -d ~/.vim/bundle ]]; then
	echo "Vundle  already installed" >> $LOG_FILE
else
	git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim 

	if [[ -d ~/.vim/bundle ]]; then
	    echo "Vundle Installed" >> $LOG_FILE
	else
	    echo "Vundle FAILED TO INSTALL!!!" >> $LOG_FILE
	fi
fi
