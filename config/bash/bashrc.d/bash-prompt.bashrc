#!/usr/bin/env bash

# Bash Configuration for the Prompt Variables.
#
# @link https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
  return
fi

#######################################################################
# Configure the PS1 variable as simple prompt.
#
# Globals:
#   PS1
#######################################################################
function bashrc::prompt::configure_ps1_simple()
{
  # NOTE:
  #
  # In addition, the following table describes the special characters
  # which can appear in the prompt variables PS0, PS1, PS2, and PS4:
  #
  #   \u    The username of the current user.
  #   \h    The hostname, up to the first '.'.
  #   \w    The current working directory,
  #         with $HOME abbreviated with a tilde.
  #   \t    The time, in 24-hour HH:MM:SS format.
  #   \n    A newline.
  #   \$    If the effective uid is 0, #, otherwise $.
  local ps1
  ps1="\n[\u@\h] \w \n"
  ps1="${ps1}\t \$ "

  export PS1="${ps1}"
}

function bashrc::prompt::main()
{
    bashrc::prompt::configure_ps1_simple
}

bashrc::prompt::main

unset -f bashrc::prompt::main
unset -f bashrc::prompt::configure_ps1_simple
