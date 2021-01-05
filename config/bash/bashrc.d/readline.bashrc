#!/usr/bin/env bash

# Bash Configuration for GNU Readline.
#
# @link https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Variables
# @link https://en.wikipedia.org/wiki/GNU_Readline

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

#######################################################################
# Configure variables for GNU Readline.
#
# Globals:
#   INPUTRC
#   XDG_CONFIG_HOME
#######################################################################
function bashrc::readline::configure()
{
  local config_home="${HOME}/.config"
  if [[ "${XDG_CONFIG_HOME:-}" != "" ]]; then
    config_home="${XDG_CONFIG_HOME}"
  fi

  # The name of the Readline initialization file.
  #
  # - Default: "$HOME/.inputrc".
  if test -e "${HOME}/.inputrc"; then
    export INPUTRC="${HOME}/.inputrc"
  elif test -e "${config_home}/readline/inputrc"; then
    export INPUTRC="${config_home}/readline/inputrc"
  fi
}

bashrc::readline::configure

unset -f bashrc::readline::configure
