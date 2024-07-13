if [[ -f ~/.vim/autoload/plug.vim ]]; then
    vim +PlugInstall +qall 
    echo "Inatall all Vim plugins" >> $LOG_FILE
fi


