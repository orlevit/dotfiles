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

# Set the editor of the command line & general to vi
set -o vi
export EDITOR=vim

# Source virtualenvwrapper if it exists
[[ -e /usr/local/bin/virtualenvwrapper.sh ]] && source /usr/local/bin/virtualenvwrapper.sh

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
		--bind 'ctrl-e:executevirtualenvwrapper{+} | xargs -o vim)'"
fi

# Source the autojump plugin
[[ -s /home/${USER}/.autojump/etc/profile.d/autojump.sh ]] && source /home/${USER}/.autojump/etc/profile.d/autojump.sh

# Set prompt color for SSH connections
if [[ -n $SSH_CLIENT ]]; then
    prompt_user_host_color='1;35'
else
    unset prompt_user_host_color # omitted on the local machine
fi

# Show git branch and indication of changes
parse_git_branch() {
    local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if [ -n "$branch" ]; then
        local status=$(git status --porcelain 2> /dev/null)
        local status_indicator=""
        if [ -n "$status" ]; then
            status_indicator="*"
        fi
        echo "($branch$status_indicator)"
    fi
}

if [[ -n $prompt_user_host_color ]]; then      # Remote color
  PS1='\[\e['$prompt_user_host_color'm\]\u@\h'
else                                           # Local color 
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]'
fi
PS1+=":\[\033[0;36m\]\w\[\033[00m\]\[\033[33m\]\$(parse_git_branch)\[\033[00m\]$"

# colors of ls command
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:';

# Source fzf-git
source ~/fzf-git.sh/fzf-git.sh
