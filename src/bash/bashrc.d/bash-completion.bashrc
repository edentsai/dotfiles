#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash
if [ -z "${BASH_VERSION:-}" ] || [ -z "${PS1:-}" ]; then
    return
fi

# Load bash completion if exists when programmable completion enabled.
function bashrc::load_bash_completion_if_exists_when_progcomp_enabled()
{
    # Return if the programmable completion disabled.
    if ! shopt -q progcomp; then
        return
    fi

    # The possible files of bash completions in priority order,
    # ONLY load the first bash completion.
    local readonly files_in_priority_order=(
        "${HOME}/opt/bash-completion/share/bash-completion/bash_completion"
        "${HOME}/opt/share/bash-completion/bash_completion"
        "/usr/local/share/bash-completion/bash_completion"
        "/usr/share/bash-completion/bash_completion"
        "${HOME}/.bash/share/bash-completion/bash_completion"
    )

    local file
    for file in "${files_in_priority_order[@]}"; do
        if test -f "${file}" && test -r "${file}"; then
            source "${file}"

            break
        fi
    done
    unset file

    # Set BASH_COMPLETION_USER_DIR for local completions with highest priority
    # Path Pattern: ${BASH_COMPLETION_USER_DIR}/completions
    #
    # @see https://github.com/scop/bash-completion#faq
    # export BASH_COMPLETION_USER_DIR="${HOME}/.bash/bash-completion"

    # Set XDG_DATA_DIRS for multiple directories of completions in priority order
    # Path Pattern: ${XDG_DATA_DIR}/bash-completion/completions
    # @see https://github.com/scop/bash-completion/blob/88ed3c712df1b72d730496e736faba493488e892/bash_completion#L2064-L2078
    local file
    local data_dir
    local data_dirs
    data_dirs="${XDG_DATA_DIRS}"
    for file in "${files_in_priority_order[@]}"; do
        data_dir=$(dirname $(dirname "${file}"))
        data_dirs="${data_dirs}:${data_dir}"
    done

    export XDG_DATA_DIRS="${data_dirs#:}"
    unset file
    unset data_dir
    unset data_dirs
}

bashrc::load_bash_completion_if_exists_when_progcomp_enabled
