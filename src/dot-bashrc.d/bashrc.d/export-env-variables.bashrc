#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Export environment variables for Locale, Terminal, Editor and etc
bashrc::export_env_variables()
{
    # Locale, Terminal, Editor and Pager
    export LANG="en_US.UTF-8"
    export LC_ALL="en_US.UTF-8"
    export TERM="screen-256color"
    export EDITOR="vim"

    # Git
    export GIT_PAGER="less"

    # MySQL Prompt
    export MYSQL_PS1="[\u@\h] : (\d)\n[\R:\m:\s] mysql> "
}

bashrc::export_env_variables
