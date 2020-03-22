#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Enhancement `cd` command for easily jump to parent directories,
# for examples:
#   - `cd ...`  instead of `cd ../..`
#   - `cd ....` instead of `cd ../../..`
#   - `cd ..[1-9]`:
#     - `cd ..2`  instead of `cd ../..`
#     - `cd ..3`  instead of `cd ../../..`
cd()
{
    # Use default behavior if the target path is a directory.
    local target_path="${1}"
    if test -d "${target_path}"; then
        builtin cd "${@}"

        return ${?}
    fi

    # Enhancement behavior when the target path is matched the RegExp patterns.
    local num=0;
    if [[ "${target_path}" =~ ^\.\.+$ ]]; then
        # `cd ...` to `cd ../..`
        # `cd ....` to `cd ../../..`
        num="${#target_path}"
    elif [[ "${target_path}" =~ ^\.\.([1-9])$ ]]; then
        # `cd ..2` to `cd ../..`
        # `cd ..3` to `cd ../../..`
        num="${BASH_REMATCH[1]}"
    fi

    if (( num > 0 )); then
        local parent_dir=""
        while (( num > 0 )); do
            parent_dir="${parent_dir}/.."
            ((num--))
        done
        parent_dir="${parent_dir:1}"

        builtin cd "${parent_dir}"

        return ${?}
    fi

    # otherwises, fallback to default behavior.
    builtin cd "${@}"

    return ${?}
}
