# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
PATH=$PATH:$HOME/.local/bin:$HOME/bin
export PATH

# If not running interactively, don't do anything(needed for remote accessing)
case $- in
    *i*) ;;
      *) return;;
esac

################################ Constants ################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

######################## shopt(shell behavior) ############################

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Case-incensitive globbing 
shopt -s nocaseglob;

# Autocorrect typos pathnames in cd command
shopt -s cdspell

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar
############################################################33 what are those??????


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# If virtualenvwrapper exists than source it
[[ -e /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/or/Downloads/google-cloud-sdk/path.bash.inc' ]; then . '/home/or/Downloads/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/or/Downloads/google-cloud-sdk/completion.bash.inc' ]; then . '/home/or/Downloads/google-cloud-sdk/completion.bash.inc'; fi

if [ -d "/opt/TurboVNC/bin/" ];then
	PATH=/opt/TurboVNC/bin:$PATH
	export PATH
fi

# source the fuzzy finder plugin ad add configurtons
if [ -f ~/.fzf.bash ]; then
	source ~/.fzf.bash
	export FZF_DEFAULT_COMMAND='find . -not -path "*/\.git/*" -type f -printf "%f\n"'
	export FZF_DEFAULT_OPTS="
		--exact
		--layout=reverse
		--info=inline
		--height=80%
		--multi
		--preview-window=:hidden
		--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
		--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
		--prompt='∼ ' --pointer='▶' --marker='✓'
		--bind '?:toggle-preview'
		--bind 'ctrl-a:select-all'
		--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
		--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'"
fi

## source the fuzzy finder plugin ad add configurtons
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#export FZF_DEFAULT_COMMAND='find . -not -path "*/\.git/*" -type f -printf "%f\n"'
#export FZF_DEFAULT_OPTS="
#--exact
#--layout=reverse
#--info=inline
#--height=80%
#--multi
#--preview-window=:hidden
#--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
#--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
#--prompt='∼ ' --pointer='▶' --marker='✓'
#--bind '?:toggle-preview'
#--bind 'ctrl-a:select-all'
#--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
#--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
#"

# Source the autojump plugin
#. /usr/share/autojump/autojump.sh
[[ -s /home/${USER}/.autojump/etc/profile.d/autojump.sh ]] && source /home/${USER}/.autojump/etc/profile.d/autojump.sh

# Set the editor of the command line & general to vi 
set -o vi
export EDITOR=vim

# source aliases & functions
source ~/.aliases
source ~/.functions

# Switch caps lock and Esc
setxkbmap -option caps:swapescape

# Color change in the command line for remote SSH connections 
if [[ -n $SSH_CLIENT ]]; then
  prompt_user_host_color='1;35'
else
  unset prompt_user_host_color # omitted on the local machine
fi
if [[ -n $prompt_user_host_color ]]; then      # Remote color
  PS1='\[\e['$prompt_user_host_color'm\]\u@\h'
else                                           # Local color 
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]'
fi
PS1+=':\[\033[01;34m\]\w\[\033[00m\]\$'

# Original linux PS1 colors, keep for now
#$PS1={debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$

export LC_ALL="en_US.UTF-8"

# colors of ls command
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

export PATH=$PATH:/usr/bin
