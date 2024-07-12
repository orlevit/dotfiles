#!/usr/bin/env bash

# Function to link dotfiles to home directory
link () {
    PROMPT="[INFO]"
    echo "$PROMPT This utility will:"
    echo "$PROMPT 1. Delete existing dotfiles in the home directory"
    echo "$PROMPT 2. Symlink dotfiles from this repository to the home directory"
    echo "$PROMPT Proceed? (y/n)"
    read resp

    if [ "$resp" = 'y' -o "$resp" = 'Y' ]; then
        # Iterate through all dotfiles in the current directory
        for object in .[^.]*; do
            # Check if the object exists (to handle cases with no dotfiles)
            if [ -e "$object" ]; then
                # Construct full path for the object in the home directory
                target="$HOME/$object"

                # Remove existing files or symlinks
                if [ -e "$target" ]; then
                    rm -rf "$target"
                    echo "Removed existing $target"
                fi

                # Create symlink
                ln -svf "$PWD/$object" "$target"
                echo "Linked $object to $HOME"
            fi
        done

        echo "$PROMPT Symlinking complete"
    else
        echo "$PROMPT Symlinking cancelled by user"
        return 1
    fi

    # Symlink tpm to ~/.tmux/plugins/tpm if it exists
    if [ -d "$PATH_TO_ADDITIONAL_PACKAGES/tpm" ]; then
        mkdir -p "$HOME/.tmux/plugins"
        ln -svf "$PATH_TO_ADDITIONAL_PACKAGES/tpm" "$HOME/.tmux/plugins/tpm"
        echo "Linked tpm to $HOME/.tmux/plugins/tpm"
    else
        echo "$PROMPT tpm is not installed in $PATH_TO_ADDITIONAL_PACKAGES"
    fi
}

# Call the link function
link
