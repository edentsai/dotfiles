#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# TODO source git-prompts.sh

# Export environment variable `$PS1` for customize Bash Prompt.
bashrc::export_env_ps1()
{
    local readonly color_reset="\[[0m\]"
    local readonly color_whitebold="\[[38;5;15m\]"
    local readonly color_lightgraybold="\[[38;5;144m\]"
    local readonly color_lightgray="\[[38;5;255m\]"
    local readonly color_red_bg="\[[48;5;88m\]"
    local readonly color_lightgray_bg="\[[48;5;237m\]"
    local readonly color_darkgray_bg="\[[48;5;234m\]"
    local readonly color_reset_bg="\[[49m\]"

    local readonly part1="${color_whitebold}${color_red_bg} \\u@\\h "
    local readonly part2="${color_lightgraybold}${color_lightgray_bg} \$(pwd) "
    local readonly part3="${color_lightgray}${color_darkgray_bg} \$(git_current_ps1) "
    local readonly part3="${part3}${color_lightgraybold}${color_lightgray_bg}"
    local readonly part3="${part3}${color_reset}${color_reset_bg}\n"
    local readonly part4="${color_lightgraybold}${color_lightgray_bg} \\t ${color_reset}${color_reset_bg} \$ "

    export PS1="${part1}${part2}${part3}${part4}"
}

bashrc::export_env_ps1
