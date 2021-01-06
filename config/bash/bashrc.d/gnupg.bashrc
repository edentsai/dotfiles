#!/usr/bin/env bash

# Bash Configuration for GnuPG.
#
# Using GnuPG subkeys for SSH authentication on macOS and Linux.
#
# @link https://www.gnupg.org
# @link https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
# @link https://www.gnupg.org/documentation/manuals/gnupg/Common-Problems.html
# @link https://gregrs-uk.github.io/2018-08-06/gpg-key-ssh-mac-debian/

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

#######################################################################
# Configure $SSH_AUTH_SOCK with GnuPG for SSH authentication.
#
# Globals:
#   BASH_SOURCE
#   SSH_AUTH_SOCK
# Returns:
#   0 if $SSH_AUTH_SOCK with GPG agent is available,
#   or 127 if one of prerequisite command not found,
#   or fails if the $SSH_AUTH_SOCK with GPG agent is not available.
#   or returns the status of the last command executed
#######################################################################
function bashrc::gnupg::configure_ssh_auth_sock()
{
  local script_file="${BASH_SOURCE[0]:-"${0}"}"

  # Skip if one of prerequisite command is not found.
  local prerequisite_commands=( \
    "ssh" \
    "gpg" \
    "gpgconf" \
  )

  local prerequisite_command
  for prerequisite_command in "${prerequisite_commands[@]}"; do
    if ! command -v "${prerequisite_command}" > /dev/null 2>&1; then
      printf "%s: %s: %s \n" \
        "${script_file}: ${FUNCNAME} failed at line ${LINENO}" \
        "Prerequisite command not found" \
        "${prerequisite_command}" \
        1>&2

      local readonly EXIT_STATUS_COMMAND_NOT_FOUND="127"

      return "${EXIT_STATUS_COMMAND_NOT_FOUND}"
    fi
  done

  local ssh_socket
  ssh_socket="$(gpgconf --list-dirs agent-ssh-socket)"

  local last_exit_status="${?}"
  if [[ "${last_exit_status}" != "0" ]]; then
    printf "%s: %s: %s \n" \
      "${script_file}: ${FUNCNAME} failed at line ${LINENO}" \
      "Execute 'gpgconf --list-dirs agent-ssh-socket' failed" \
      "exit status ${last_exit_status}" \
      1>&2

    return "${last_exit_status}"
  fi

  export SSH_AUTH_SOCK="${ssh_socket}"

  return 0
}

function bashrc::gnupg::main()
{
  bashrc::gnupg::configure
  bashrc::gnupg::configure_ssh_auth_sock
}

bashrc::gnupg::main

unset -f bashrc::gnupg::main
unset -f bashrc::gnupg::configure
unset -f bashrc::gnupg::configure_ssh_auth_sock
