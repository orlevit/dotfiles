# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# Source .bashrc if it exists
if [ -f ~/.bashrc ]; then
    . ~/.bashrc
fi

# Set PATH
PATH=$PATH:$HOME/.local/bin:$HOME/bin:/usr/bin
export PATH
