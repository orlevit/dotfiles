#!/usr/bin/env bash

source .exports

# Function to link dotfiles to the home directory
link() {
    PROMPT="[INFO]"
    echo "$PROMPT This utility will:"
    echo "$PROMPT 1. Delete existing dotfiles in the home directory"
    echo "$PROMPT 2. Symlink dotfiles from this repository to the home directory"
    echo "$PROMPT Proceed? (y/n)"
    read resp

    if [[ "$resp" == 'y' || "$resp" == 'Y' ]]; then
        # Iterate through all dotfiles in the DOTFILES_DIR
        for object in "$DOTFILES_DIR"/.[^.]*; do
            # Check if the object exists
            if [ -e "$object" ]; then
                # Extract the filename from the full path
                filename=$(basename "$object")
                # Construct full path for the object in the home directory
                target="$HOME/$filename"

                # Remove existing files, directories, or symlinks
                if [ -e "$target" ]; then
                    rm -rf "$target"
                fi

                # Handle the .config folder
                if [ "$filename" == ".config" ] && [ -d "$object" ]; then
                    # Ensure the .config directory exists in $HOME
                    mkdir -p "$HOME/.config"

                    # Iterate through each subdirectory in .config
                    for subdir in "$object"/*; do
                        subdir_name=$(basename "$subdir")
                        config_target="$HOME/$filename/$subdir_name"

                        # Remove existing subdirectory or symlink
                        if [ -e "$config_target" ]; then
                            rm -rf "$config_target"
                        fi

                        # Symlink the subdirectory
                        ln -svf "$subdir" "$config_target"
                    done
                else
                    # Create symlink for other dotfiles
                    ln -svf "$object" "$target"
                fi
            fi
        done

        # Symlink tpm to ~/.tmux/plugins/tpm if it exists
        if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tmux_plugin_manager" ]; then
            mkdir -p "$HOME/.tmux/plugins"
            ln -svf "$PATH_TO_ADDITIONAL_PACKAGES/tmux_plugin_manager" "$HOME/.tmux/plugins/tmux_plugin_manager"
            echo "Linked tpm to $HOME/.tmux/plugins/tmux_plugin_manager/tpm"
        else
            echo "$PROMPT tpm is not installed in $PATH_TO_ADDITIONAL_PACKAGES"
        fi

        echo "$PROMPT Symlinking complete"

    else
        echo "$PROMPT Symlinking cancelled by user"
        return 1
    fi
}

# Call the link function
link
