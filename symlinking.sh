!/usr/bin/env bash

declare -a INCLUDING=(".bash_profile" ".bashrc" ".aliases" ".vimrc" ".functions")
for file in ${INCLUDING[@]}; do
	ln -sv ~/Projects/dotfiles/$file ~
	#echo "~/Projects/dotfiles/$file" 
done
