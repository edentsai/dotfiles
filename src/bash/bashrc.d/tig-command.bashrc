#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `tig` command.
bashrc::configure_tig_command()
{
    # tig reflog. (https://github.com/jonas/tig/issues/538#issuecomment-260842760)
    alias tig-reflog="git reflog --pretty=raw | tig --pretty=raw"
}

bashrc::configure_tig_command
