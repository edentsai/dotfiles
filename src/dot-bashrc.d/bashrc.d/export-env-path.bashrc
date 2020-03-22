#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Unshift paths to the environment variable `$PATH`:
# - Remove specified paths from $PATH if already exists.
# - Add specified paths to the beginning in $PATH.
# - For examples:
#   - bashrc::unshift_paths_to_env_path "/path1"
#   - bashrc::unshift_paths_to_env_path "/path1:/path2"
bashrc::unshift_paths_to_env_path()
{
    local readonly EXIT_CODE_GENERAL_ERROR=1

    local unshift_paths="${1}"
    if [[ "${unshift_paths}" == "" ]]; then
        return ${EXIT_CODE_GENERAL_ERROR}
    fi

    # Split unshift paths with the delimiter ':' into multiple lines.
    local paths="${PATH}"
    local unshift_path
    unshift_paths="${unshift_paths//:/\\\n}"
    while IFS= read -r unshift_path; do
        # Remove the unshift path from $PATH if it already exists.
        paths="$(echo ":${paths}:" | sed -e "s:\:${unshift_path}\::\::g" -e "s/^:*//" -e "s/:*$//")"
    done < <(echo -e "${unshift_paths//:/\\\n}")

    # Unshift paths into $PATH.
    export PATH="${unshift_paths}:${paths}"
}

# Export the envrionment variable `$PATH`.
bashrc::export_env_path()
{
    bashrc::unshift_paths_to_env_path "/bin"
    bashrc::unshift_paths_to_env_path "/sbin"
    bashrc::unshift_paths_to_env_path "/usr/bin"
    bashrc::unshift_paths_to_env_path "/usr/sbin"
    bashrc::unshift_paths_to_env_path "/usr/local/bin"
    bashrc::unshift_paths_to_env_path "/usr/local/sbin"

    bashrc::unshift_paths_to_env_path "${HOME}/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/.bin"
    bashrc::unshift_paths_to_env_path "${HOME}/.composer/vendor/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/.local/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/.npm/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/.bash/submodules/fzf/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/Library/Python/2.7/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/composer/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/tig/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/tmux/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/ncurses6/bin"
    bashrc::unshift_paths_to_env_path "${HOME}/opt/byacc/bin"
}

bashrc::export_env_path
