!/usr/bin/env bash
PROMPT='[Boostrap]'

# Link the files in $HOME to the dotfile in the directory
link () {
	echo "$PROMPT This utility do:"
	echo "$PROMPT 1. Will delete the dot files in home directory" 
	echo "$PROMPT 2. Symlink the files in this repo to the home directory"
	echo "$PROMPT Proceed? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for file in $(ls -A|grep -E '^\.'|grep -Ev '.git$|*.md') ; do
			[ -f "$HOME/$file" ] && rm  "$HOME/$file"
			ln -svf "$PWD/$file" "$HOME"
		done
		echo "$PROMPT Symlinking complete"
	else
		echo "$PROMPT Symlinking cancelled by user"
		return 1
	fi
}

link
