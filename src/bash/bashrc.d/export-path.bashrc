#!/usr/bin/env bash
# vim: set filetype=sh

# Export the PATH environment variable.
function bashrc::export_path()
{
    # The 'PATH' environment variable.
    unshift_paths_to_global "/bin"
    unshift_paths_to_global "/sbin"
    unshift_paths_to_global "/usr/bin"
    unshift_paths_to_global "/usr/sbin"
    unshift_paths_to_global "/usr/games"
    unshift_paths_to_global "/usr/local/bin"
    unshift_paths_to_global "/usr/local/sbin"

    unshift_paths_to_global "${HOME}/bin"
    unshift_paths_to_global "${HOME}/.bin"
    unshift_paths_to_global "${HOME}/.composer/vendor/bin"
    unshift_paths_to_global "${HOME}/.local/bin"
    unshift_paths_to_global "${HOME}/.npm/bin"
    unshift_paths_to_global "${HOME}/.bash/submodules/fzf/bin"
    unshift_paths_to_global "${HOME}/Library/Python/2.7/bin"
    unshift_paths_to_global "${HOME}/opt/bin"
    unshift_paths_to_global "${HOME}/opt/composer/bin"
    unshift_paths_to_global "${HOME}/opt/tig/bin"
    unshift_paths_to_global "${HOME}/opt/tmux/bin"
    unshift_paths_to_global "${HOME}/opt/ncurses6/bin"
    unshift_paths_to_global "${HOME}/opt/byacc/bin"
}

bashrc::export_path
