#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure env variables and aliases for `man` command.
bashrc::configure_man_command()
{
    # MANPAGER: Program used to display files.
    if command -v "most" > /dev/null 2>&1; then
        # Use `most` command as man pager better if `most` command is installed.
        export MANPAGER="most -s"
    elif command -v "less" > /dev/null 2>&1; then
        # Use `less` command as default man pager if `less` command is installed.
        export MANPAGER="less -Is"
    fi

    # List $MANPATH and force output to be one entry per line.
    alias manpath="echo -e \${MANPATH//:/\\\n}"
}

# Unshift manpaths to the environment variable `$MANPATH`:
# - Remove specified manpaths from $MANPATH if already exists.
# - Add specified manpaths to the beginning in $MANPATH.
# - For examples:
#   - bashrc::unshift_manpaths_to_env_manpath "/path1"
#   - bashrc::unshift_manpaths_to_env_manpath "/path1:/path2"
bashrc::unshift_manpaths_to_env_manpath()
{
    local readonly EXIT_CODE_GENERAL_ERROR=1

    local unshift_manpaths="${1}"
    if [[ "${unshift_manpaths}" == "" ]]; then
        return ${EXIT_CODE_GENERAL_ERROR}
    fi

    # Split unshift manpaths with the delimiter ':' into multiple lines.
    local manpaths="${MANPATH}"
    local unshift_manpath
    unshift_manpaths="${unshift_manpaths//:/\\\n}"
    while IFS= read -r unshift_manpath; do
        # Remove the unshift path from $MANPATH if it already exists.
        manpaths="$(echo ":${manpaths}:" | sed -e "s:\:${unshift_manpath}\::\::g" -e "s/^:*//" -e "s/:*$//")"
    done < <(echo -e "${unshift_manpaths//:/\\\n}")

    # Unshift manpaths into $MANPATH.
    export MANPATH="${unshift_manpaths}:${manpaths}"
}

# Export the envrionment variable `$MANPATH`.
bashrc::export_env_manpath()
{
    bashrc::unshift_manpaths_to_env_manpath "/usr/share/man"
}

bashrc::configure_man_command
bashrc::export_env_manpath
