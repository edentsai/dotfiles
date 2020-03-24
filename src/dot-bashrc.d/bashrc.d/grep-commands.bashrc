#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure aliases with default options for `grep`, `egrep` and `fgrep` commands.
bashrc::configure_grep_aliases()
{
    # Use alias with default options instead of GREP_OPTIONS and GREP_COLORS for cross platform.
    local grep_options=""
    if echo "test" | grep --color=auto "test" > /dev/null 2>&1; then
        grep_options="${grep_options} --color=auto";
    fi

    if echo "test" | grep --directories=skip "test" > /dev/null 2>&1; then
        grep_options="${grep_options} --directories=skip"
    fi

    if echo "test" | grep --exclude=\.git "test" > /dev/null 2>&1; then
        grep_options="${grep_options} --exclude=\.swp --exclude=\.svn --exclude=\.git"
    fi

    alias grep="grep ${grep_options}"
    alias egrep="egrep ${grep_options}"
    alias fgrep="fgrep ${grep_options}"
}

bashrc::configure_grep_aliases
