#!/usr/bin/env bash

# Bash Completion Configuration.
#
# NOTE:
#
# - Completion of valid paths involving variables adds backslashes.
#   https://github.com/scop/bash-completion/issues/290
#
# @link https://github.com/scop/bash-completion
# @link https://github.com/scop/bash-completion#faq
# @link https://github.com/scop/bash-completion/blob/master/doc/bash_completion.txt
# @link https://github.com/scop/bash-completion/blob/master/bash_completion.sh.in

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
  return
fi

#######################################################################
# Configure variables for Bash completion.
#
# Globals:
#   BASH_COMPLETION_USER_DIR
#   BASH_COMPLETION_USER_FILE
#   HOME
#   XDG_CONFIG_HOME
#   XDG_DATA_HOME
#######################################################################
function bashrc::bash_completion::configure()
{
  local config_home="${HOME}/.config"
  if [[ "${XDG_CONFIG_HOME:-}" != "" ]]; then
    config_home="${XDG_CONFIG_HOME}"
  fi

  local data_home="${HOME}/.local/share"
  if [[ "${XDG_DATA_HOME:-}" != "" ]]; then
    data_home="${XDG_DATA_HOME}"
  fi

  # Sourced late by bash_completion,
  # pretty much after everything else.
  #
  # - Use this file for example to load additional completions,
  #   and to remove and override ones installed by bash_completion.
  # - Defaults to `$HOME/.bash_completion` if unset or null.
  if [[ "${BASH_COMPLETION_USER_FILE:-}" == "" ]]; then
    export BASH_COMPLETION_USER_FILE="${config_home}/bash/bash_completion"
  fi

  # Question:
  #
  #   Where should I install my own local completions?
  #
  # Answer:
  #
  #   Put them in the completions subdir of
  #   `$BASH_COMPLETION_USER_DIR` to have them loaded automatically
  #   on demand when the respective command is being completed.
  #
  #   $BASH_COMPLETION_USER_DIR is defaults to
  #   `$XDG_DATA_HOME/bash-completion`
  #   or `$HOME/.local/share/bash-completion`
  #   if $XDG_DATA_HOME is not set)
  if [[ "${BASH_COMPLETION_USER_DIR:-}" == "" ]]; then
    export BASH_COMPLETION_USER_DIR="${data_home}/bash-completion"
  fi

  # Bash Completion will source all of files
  # by `$BASH_COMPLETION_COMPAT_DIR/*` at startup,
  # that cause you cannot use a newer completion script
  # by BASH_COMPLETION_USER_DIR.
  #
  # For example, there are two completion scripts
  # with difference versions for the `git` command:
  #
  # 1. older script: `$BASH_COMPLETION_COMPAT_DIR/git-completion.bash`.
  # 2. newer script: `$BASH_COMPLETION_USER_DIR/git-completion.bash`.
  #
  # Bash completion will source the older script
  # `$BASH_COMPLETION_COMPAT_DIR/git-completion.bash` at startup,
  # when Git completion already existed in current shell,
  # the newer script `$BASH_COMPLETION_USER_DIR/git-completion.bash`
  # will never be source.
  #
  # @link https://github.com/scop/bash-completion/blob/2.11/bash_completion#L2244-L2252
  #
  # NOTE:
  #   Handle `$BASH_COMPLETION_COMPAT_DIR` if you have newer completions
  #   in `$BASH_COMPLETION_USER_DIR` or `$XDG_DATA_DIRS`.
  #
  # # if [[ "${BASH_COMPLETION_COMPAT_DIR:-}" == "" ]]; then
  # #    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
  # # fi
}

#######################################################################
# Set up Bash completion if the "progcomp" shell option is enabled.
#
# - Source the first `bash_completion` script
#   in $XDG_DATA_HOME or $XDG_DATA_DIRS if exists.
# - How to enable or disable the "progcomp" shell option?
#
#     ```shell
#     # Show status of "progcomp".
#     $ shopt "progcomp"
#     progcomp on
#
#     # Enable "progcomp".
#     $ shopt -s "progcomp"
#
#     # Disable "progcomp"
#     $ shopt -u "progcomp"
#     ```
#
# Globals:
#   HOME
#   XDG_DATA_HOME
#   XDG_DATA_DIRS
# Returns:
#   0 if progcomp is disabled,
#   or `bash_completion` have already been sourced,
#   or `bash_completion` script not found,
#   otherwise, returns the status of the last command executed
#   in the `bash_completion` script,
#   fails if the `bash_completion` cannot be read.
#######################################################################
function bashrc::bash_completion::set_up_if_progcomp_enabled()
{
  # Skip if the programmable completion disabled.
  if ! shopt -q "progcomp"; then
    return 0
  fi

  # Skip if Bash Completion have already been sourced.
  if [[ "${BASH_COMPLETION_VERSINFO:-}" != "" ]]; then
    return 0
  fi

  # Collect user directories from $XDG_DATA_HOME and $XDG_DATA_DIRS.
  local data_home="${HOME}/.local/share"
  if [[ "${XDG_DATA_HOME:-}" != "" ]]; then
    data_home="${XDG_DATA_HOME}"
  fi

  local data_dirs="/usr/local/share:/usr/share"
  if [[ "${XDG_DATA_DIRS:-}" ]]; then
    data_dirs="${XDG_DATA_DIRS}"
  fi

  local ordered_user_dirs=("${data_home}")
  local data_dir
  while IFS= read -r data_dir; do
    ordered_user_dirs+=("${data_dir}")
  done < <(echo -e "${data_dirs//:/\\\n}")

  # Source the first `bash_completion` script
  # from the user directories.
  local user_dir
  local bash_completion_file
  for user_dir in "${ordered_user_dirs[@]}"; do
    bash_completion_file="${user_dir}/bash-completion/bash_completion"
    if test -r "${bash_completion_file}"; then
      source "${bash_completion_file}"

      local last_exit_status="${?}"
      if [[ "${last_exit_status}" != "0" ]]; then
        local script_file="${BASH_SOURCE[0]:-"${0}"}"
        printf "%s: %s: %s: %s \n" \
          "${script_file}" \
          "${FUNCNAME} failed at line ${LINENO}" \
          "source ${bash_completion_file} failed" \
          "exit status ${last_exit_status}" \
          1>&2

        return "${last_exit_status}"
      fi

      break
    fi
  done

  return 0
}

function bashrc::bash_completion::main()
{
  bashrc::bash_completion::configure
  bashrc::bash_completion::set_up_if_progcomp_enabled
}

bashrc::bash_completion::main

unset -f bashrc::bash_completion::main
unset -f bashrc::bash_completion::configure
unset -f bashrc::bash_completion::set_up_if_progcomp_enabled
