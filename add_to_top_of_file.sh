#!/usr/bin/env bash
# Add string to top of a file

FILE="$1"
TOP_CONTENT="$2"

TEMP_FILE=$(mktemp)  # Create a temporary file

# Check if the file exists
if [ -f "$FILE" ]; then
    # Create temporary file with top content and existing file content
    echo "$TOP_CONTENT" > "$TEMP_FILE"
    cat "$FILE" >> "$TEMP_FILE"

    # Replace original file with the temporary file
    mv "$TEMP_FILE" "$FILE"
    echo "Content added to the top of $FILE"
else
    echo "Error: $FILE does not exist"
fi
