!/usr/bin/env bash

source .exports

# Link the files in $HOME to the dotfile in the directory
link () {
	echo "$PROMPT This utility do:"
	echo "$PROMPT 1. Will delete the dot files in home directory" 
	echo "$PROMPT 2. Symlink the files in this repo to the home directory"
	echo "$PROMPT Proceed? (y/n)"
	read resp
	if [ "$resp" = 'y' -o "$resp" = 'Y' ] ; then
		for object in $(ls -A|grep -E '^\.'|grep -Ev '.git$|*.md|.exports|.gitignore') ; do
			if [ -f $object ] ; then
				[ -f "$HOME/$file" ] && rm  "$HOME/$file"
				ln -svf "$PWD/$object" "$HOME"
			fi

			if [ -d $object ] ; then
				file=$(find $object -type f)
				dirs=$(dirname  $file)
				[ -f "$HOME/$file" ] && rm  "$HOME/$file"
				mkdir -p "${HOME}/${dirs}"
				ln -svf "${PWD}/${file}" "${HOME}/${dirs}"
			fi
		done
		echo "$PROMPT Symlinking complete"
	else
		echo "$PROMPT Symlinking cancelled by user"
		return 1
	fi
}

link
