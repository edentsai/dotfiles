#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Unshift paths to the environment variable `$XDG_DATA_DIRS`:
# - Remove specified paths from $XDG_DATA_DIRS if already exists.
# - Add specified paths to the beginning in $XDG_DATA_DIRS.
# - For examples:
#   - bashrc::unshift_paths_to_env_path "/path1"
#   - bashrc::unshift_paths_to_env_path "/path1:/path2"
bashrc::unshift_paths_to_env_xdg_data_dirs()
{
    local readonly EXIT_CODE_GENERAL_ERROR=1

    local unshift_paths="${1}"
    if [[ "${unshift_paths}" == "" ]]; then
        return ${EXIT_CODE_GENERAL_ERROR}
    fi

    # Split unshift paths with the delimiter ':' into multiple lines.
    local paths="${XDG_DATA_DIRS}"
    local unshift_path
    unshift_paths="${unshift_paths//:/\\\n}"
    while IFS= read -r unshift_path; do
        # Remove the unshift path from $PATH if it already exists.
        paths="$(echo ":${paths}:" | sed -e "s:\:${unshift_path}\::\::g" -e "s/^:*//" -e "s/:*$//")"
    done < <(echo -e "${unshift_paths//:/\\\n}")

    # Unshift paths into $XDG_DATA_DIRS.
    export XDG_DATA_DIRS="${unshift_paths}:${paths}"
}

# Export environment variable `$XDG_DATA_DIRS`
bashrc::export_env_xdg_data_dirs()
{
    bashrc::unshift_paths_to_env_xdg_data_dirs "${HOME}/.bash/share"
    bashrc::unshift_paths_to_env_xdg_data_dirs "/usr/share"
    bashrc::unshift_paths_to_env_xdg_data_dirs "/usr/local/share"
    bashrc::unshift_paths_to_env_xdg_data_dirs "${HOME}/opt/share"
    bashrc::unshift_paths_to_env_xdg_data_dirs "${HOME}/opt/bash-completion/share"
}

# Source bash completion if exists when programmable completion enabled.
bashrc::source_bash_completion_if_exists_when_progcomp_enabled()
{
    # Return if the programmable completion disabled.
    if ! shopt -q progcomp; then
        return
    fi

    local data_dirs="${XDG_DATA_DIRS}"
    if [[ "${XDG_DATA_DIRS}" == "" ]]; then
        return
    fi

    # Source the first bash completion at $XDG_DATA_DIR/bash-completion/bash_completion
    local data_dir
    local file
    while IFS= read -r data_dir; do
        bash_completion_file="${data_dir}/bash-completion/bash_completion"
        if test -r "${bash_completion_file}"; then
            source "${bash_completion_file}"

            break
        fi
    done < <(echo -e "${XDG_DATA_DIRS//:/\\\n}")
}

bashrc::export_env_xdg_data_dirs
bashrc::source_bash_completion_if_exists_when_progcomp_enabled
