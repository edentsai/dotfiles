#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure aliases for `tig` command.
bashrc::configure_tig_command()
{
    # tig with reflog
    # @see https://github.com/jonas/tig/issues/538#issuecomment-260842760
    alias tig-reflog="git reflog --pretty=raw | tig --pretty=raw"
}

bashrc::configure_tig_command
