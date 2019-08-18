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

# Enhancement `cd` command.
# - `cd ...`  instead of `cd ../..`
# - `cd ....` instead of `cd ../../..`
# - `cd ..[1-9]`:
#   - `cd ..2`  instead of `cd ../..`
#   - `cd ..3`  instead of `cd ../../..`
function cd()
{
    local target_path="$1"
    local dir="";
    if [[ "$target_path" =~ ^\.\.+$ ]]; then
        # `cd ...` to `cd ../..`
        # `cd ....` to `cd ../../..`
        local num=${#1};
        while [ $num -ne 1 ]; do
            dir="${dir}../"
            ((num--))
        done
        builtin cd "$dir"
    elif [[ "$target_path" =~ ^\.\.([1-9])$ ]]; then
        # `cd ..2` to `cd ../..`
        # `cd ..3` to `cd ../../..`
        local num="${BASH_REMATCH[1]}"
        while [ $num -ne 0 ]; do
            dir="${dir}../"
            ((num--))
        done
        builtin cd "$dir"
    else
        builtin cd "$@"
    fi
}

# Display the last commit id of current branch.
function git_last_commit_id()
{
    if [ -z "$(__git_ps1)" ]; then
        return
    fi

    local last_commit_id=`git rev-parse --short HEAD 2>/dev/null`
    if [ -n "$last_commit_id" ]; then
        echo "$last_commit_id"
    fi
}

# Get time since the git last commit.
function git_since_last_commit()
{
    # Get last commit time
    local last_commit=`git log --pretty=format:%at -1 2>/dev/null`
    if [ -z "$last_commit" ]; then
        return
    fi

    # Calculate since last commit
    local now=`date +%s`
    local seconds_since_last_commit=$((now - last_commit))
    local minutes_since_last_commit=$((seconds_since_last_commit / 60))
    local hours_since_last_commit=$((minutes_since_last_commit / 60))
    local minutes_since_last_commit=$((minutes_since_last_commit % 60))

    echo "${hours_since_last_commit}h ${minutes_since_last_commit}m"
}

# Display git current ps1.
function git_current_ps1()
{
    local git_ps1=`__git_ps1`
    if [ -z "$git_ps1" ]; then
        return
    fi

    local last_commit_id=`git_last_commit_id`
    if [ -n "$last_commit_id" ]; then
        git_ps1="$git_ps1 > $last_commit_id"
    fi

    local since_last_commit=`git_since_last_commit`
    if [ -n "$since_last_commit" ]; then
        git_ps1="$git_ps1 > $since_last_commit"
    fi

    echo "$git_ps1"
}
