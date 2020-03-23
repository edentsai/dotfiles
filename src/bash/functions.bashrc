#!/usr/bin/env bash
# vim: set filetype=sh

# Source file if it exists.
function source_file_if_exists()
{
    local file_path="$1"
    if [ -f "$file_path" ]; then
        source "$file_path"
    fi
}

# Source files in directory if the directory exists.
function source_files_in_directory_if_exists()
{
    local directory_path="$1"
    if [ -d "$directory_path" ]; then
        for content_path in $directory_path/*; do
            if [ -d "$content_path" ]; then
                source_files_directory_if_exists "$content_path"
            elif [ -f "$content_path" ]; then
                source "$content_path"
            fi
        done
    fi
}
