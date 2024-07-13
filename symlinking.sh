#!/usr/bin/env bash

source .exports

# Function to link dotfiles to home directory
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

                # Remove existing files or symlinks
                if [ -f "$target" ]; then
                    rm -rf "$target"
                fi

                # Check if the object is the .config folder
                if [ "$filename" == ".config" ] && [ -d "$object" ]; then
                    # Create dir if not exists
                    home_config_path="$HOME/$filename"
                    if [ ! -d "$home_config_path" ]; then
                        mkdir -p "$home_config_path"
                    fi

                    # Link specific files inside .config
                    for config_file in "${DOT_CONFIG_DIR_LINK[@]}"; do
                        config_path="$object/$config_file"
                        if [ -e "$config_path" ]; then
                            ln -svf "$config_path" "$HOME/$filename/$config_file"
                        else
                            echo "$PROMPT $config_path does not exist"
                        fi
                    done

                else
                    # Create symlink for other dotfiles
                    ln -svf "$object" "$target"
                fi
            fi
        done

        # Symlink tpm to ~/.tmux/plugins/tpm if it exists
        if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tpm" ]; then
            mkdir -p "$HOME/.tmux/plugins"
            ln -svf "$PATH_TO_ADDITIONAL_PACKAGES/tpm" "$HOME/.tmux/plugins/tpm"
            echo "Linked tpm to $HOME/.tmux/plugins/tpm"
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

