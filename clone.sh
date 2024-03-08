#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./clone.sh

Git clone repos passed from stdin.

'
    exit
fi

# Define the directory where repositories will be cloned
TARGET_DIR="$HOME/src"

# Check if the target directory exists, if not, create it
if [ ! -d "$TARGET_DIR" ]; then
    echo "Creating directory $TARGET_DIR"
    mkdir -p "$TARGET_DIR"
fi

# Read from stdin (piped input) and clone each repository into the target directory
while read -r repo_url; do
    if [ -n "$repo_url" ]; then # Check if the line is not empty
        repo_name=$(basename "$repo_url" .git) # Extract the repository name
        target_path="$TARGET_DIR/$repo_name"
        if [ -d "$target_path" ]; then
            echo "Repository $repo_name already exists, skipping..."
        else
            echo "Cloning $repo_url into $target_path"
            git clone "$repo_url" "$target_path"
        fi
    fi
done

echo "Cloning complete."
