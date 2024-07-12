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
        # Iterate through all files and directories except for certain exclusions
        for object in $(ls -A | grep -E '^\.' | grep -Ev '\.git$|\.md|\.exports|\.gitignore'); do
            # Construct full path for the object in the home directory
            target="$HOME/$object"

            # Remove existing files or symlinks
            if [ -e "$target" ]; then
                rm -rf "$target"
                echo "Removed existing $target"
            fi

            # Check if object is a file
            if [ -f "$object" ]; then
                ln -svf "$PWD/$object" "$HOME"
                echo "Linked $object to $HOME"
            fi

            # Check if object is a directory
            if [ -d "$object" ]; then
                # Handle .config directory separately
                if [ "$object" = ".config" ]; then
                    find ".config" -type f | while IFS= read -r file; do
                        rel_path="${file#./}"
                        mkdir -p "$HOME/$(dirname "$rel_path")"
                        ln -svf "$PWD/$file" "$HOME/$rel_path"
                        echo "Linked $file to $HOME/$rel_path"
                    done
                else
                    # Find all files recursively in the directory
                    find "$object" -type f | while IFS= read -r file; do
                        # Get relative path of file inside the directory
                        rel_path="${file#./}"
                        # Create directories if they don't exist in home directory
                        mkdir -p "$HOME/$(dirname "$rel_path")"
                        # Create symlink
                        ln -svf "$PWD/$file" "$HOME/$rel_path"
                        echo "Linked $file to $HOME/$rel_path"
                    done
                fi
            fi
        done

        echo "$PROMPT Symlinking complete"
    else
        echo "$PROMPT Symlinking cancelled by user"
        return 1
    fi
}

# Call the link function
link
