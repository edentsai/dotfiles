#!/usr/bin/env bash
# vim: set filetype=sh

# Customize Bash Prompt (PS1).

# Export PS1 environment variable for customize Bash Prompt.
function bashrc::export_ps1()
{
    local readonly color_reset="\[[0m\]"
    local readonly color_whitebold="\[[38;5;15m\]"
    local readonly color_lightgraybold="\[[38;5;144m\]"
    local readonly color_lightgray="\[[38;5;255m\]"
    local readonly color_red_bg="\[[48;5;88m\]"
    local readonly color_lightgray_bg="\[[48;5;237m\]"
    local readonly color_darkgray_bg="\[[48;5;234m\]"
    local readonly color_reset_bg="\[[49m\]"

    local readonly ps1_part1="${color_whitebold}${color_red_bg} \\u@\\h "
    local readonly ps1_part2="${color_lightgraybold}${color_lightgray_bg} \$(pwd) "
    local readonly ps1_part3="${color_lightgray}${color_darkgray_bg} \$(git_current_ps1) "
    local readonly ps1_part3="${ps1_part3}${color_lightgraybold}${color_lightgray_bg}"
    local readonly ps1_part3="${ps1_part3}${color_reset}${color_reset_bg}\n"
    local readonly ps1_part4="${color_lightgraybold}${color_lightgray_bg} \\t ${color_reset}${color_reset_bg} \$ "

    export PS1="${ps1_part1}${ps1_part2}${ps1_part3}${ps1_part4}"
}

bashrc::export_ps1
