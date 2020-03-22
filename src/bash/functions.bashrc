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

# Unshift paths to $PATH:
# - Remove specified paths from $PATH if those already exists,
# - Prepend specified paths to the beginning in $PATH.
# - Example
#   $ unshift_paths_to_global "/path1"
#   $ unshift_paths_to_global "/path1:/path2"
function unshift_paths_to_global()
{
    # Remove the new path from $PATH if it already exists.
    local new_paths="$1"

    if [ -z "$new_paths" ]; then
        return 0
    fi

    local paths="$PATH"
    local new_path
    for new_path in $(echo -e ${new_paths//:/\\\n}); do
        paths=`echo ":$paths:" | sed -e "s:\:$new_path\::\::g" -e "s/^://" -e "s/:$//"`
    done

    export PATH="$new_paths:$paths"
}

# Unshift paths to $MANPATH:
# - Remove specified paths from $MANPATH if those already exists,
# - Prepend specified paths to the beginning in $MANPATH.
# - Example
#   $ unshift_manpaths_to_global "/path1"
#   $ unshift_manpaths_to_global "/path1:/path2"
function unshift_manpaths_to_global()
{
    # Remove the new path from $MANPATH if it already exists.
    local new_paths="$1"

    if [ -z "$new_paths" ]; then
        return 0
    fi

    local paths="$MANPATH"
    local new_path
    for new_path in $(echo -e ${new_paths//:/\\\n}); do
        paths=`echo ":$paths:" | sed -e "s:\:$new_path\::\::g" -e "s/^://" -e "s/:$//"`
    done

    export MANPATH="$new_paths:$paths"
}
