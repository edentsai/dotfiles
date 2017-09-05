#!/usr/bin/env bash
# vim: set filetype=sh
#
# Customize Bash Prompt (PS1).
#

color_reset="\[[0m\]"
color_whitebold="\[[38;5;15m\]"
color_lightgraybold="\[[38;5;144m\]"
color_lightgray="\[[38;5;255m\]"
color_red_bg="\[[48;5;88m\]"
color_lightgray_bg="\[[48;5;237m\]"
color_darkgray_bg="\[[48;5;234m\]"
color_reset_bg="\[[49m\]"
ps1_part1="${color_whitebold}${color_red_bg} \\u@\\h "
ps1_part2="${color_lightgraybold}${color_lightgray_bg} \$(pwd) "
ps1_part3="${color_lightgray}${color_darkgray_bg} \$(git_current_ps1) "
ps1_part3="${ps1_part3}${color_lightgraybold}${color_lightgray_bg}"
ps1_part3="${ps1_part3}${color_reset}${color_reset_bg}\n"
ps1_part4="${color_lightgraybold}${color_lightgray_bg} \\t ${color_reset}${color_reset_bg} \$ "
export PS1="${ps1_part1}${ps1_part2}${ps1_part3}${ps1_part4}"
