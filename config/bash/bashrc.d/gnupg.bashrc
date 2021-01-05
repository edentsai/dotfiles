#!/usr/bin/env bash

# Bash Configuration for GnuPG.
#
# Using GnuPG subkeys for SSH authentication on macOS and Linux.
#
# @link https://www.gnupg.org
# @link https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
# @link https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
  return
fi

#######################################################################
# Configure variables for GnuPG.
#
# Globals:
#   HOME
#   XDG_DATA_HOME
#   GNUPGHOME
#   GPG_TTY
#######################################################################
function bashrc::gnupg::configure()
{
  local data_home="${HOME}/.local/share"
  if [[ "${XDG_DATA_HOME:-}" != "" ]]; then
    data_home="${XDG_DATA_HOME}"
  fi

  # TODO: Use `${XDG_DATA_HOME}/gnupg` as GnuPG home directory.
  #
  # The GnuPG home directory.
  export GNUPGHOME="${HOME}/.gnupg"

  # To allows GPG agent ask your passphrase in terminal.
  #
  # - It is important that this environment variable
  #   always reflects the output of the `tty` command.
  #
  # @link https://www.gnupg.org/documentation/manuals/gnupg/Agent-Examples.html
  export GPG_TTY="$(tty)"
}

function bashrc::gnupg::main()
{
  bashrc::gnupg::configure
}

bashrc::gnupg::main

unset -f bashrc::gnupg::main
unset -f bashrc::gnupg::configure
