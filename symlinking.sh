!/usr/bin/env bash

#declare -a INCLUDING=(".bash_profile" ".bashrc" ".aliases" ".vimrc" ".functions")
##for file in ${INCLUDING[@]}; do
#	ln -sv ~/Projects/dotfiles/$file ~
#	#echo "~/Projects/dotfiles/$file" 
#done
export PATH_TO_DEV="$HOME/"

PROMPT='[Boostrap]'

# Initialize a few things
init () {
	echo "$PROMPT Making a Projects folder in $PATH_TO_DEV if it doesn't already exist"
	mkdir -p "$PATH_TO_DEV"
}

# Link the files in $HOME to the dotfile in the directory
link () {
	echo "$PROMPT This utility will symlink the files in this repo to the home directory"
	echo "$PROMPT Proceed? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for file in $(ls -A|grep -E '^\.'|grep -Ev '.git$|*.md') ; do
			ln -sv "$PWD/$file" "$HOME"
		done
		# TODO: source files here?
		echo "$PROMPT Symlinking complete"
	else
		echo "$PROMPT Symlinking cancelled by user"
		return 1
	fi
}

init
link
