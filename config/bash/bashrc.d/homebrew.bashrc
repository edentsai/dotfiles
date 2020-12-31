#!/usr/bin/env bash

# Bash Configuration for Homebrew on macOS / Linux.
#
# @link https://brew.sh
# @link https://docs.brew.sh
# @link https://docs.brew.sh/Manpage#environment

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

#######################################################################
# Configure variables for `brew` command.
#
# Globals:
#   HOME
#   XDG_CACHE_HOME
#   XDG_CONFIG_HOME
#   HOMEBREW_AUTO_UPDATE_SECS
#   HOMEBREW_BAT
#   HOMEBREW_BAT_CONFIG_PATH
#   HOMEBREW_CACHE
#   HOMEBREW_CASK_OPTS
#   HOMEBREW_CLEANUP_MAX_AGE_DAYS
#   HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS
#   HOMEBREW_DISPLAY_INSTALL_TIMES
#   HOMEBREW_FAIL_LOG_LINES
#   HOMEBREW_LOGS
#   HOMEBREW_NO_ANALYTICS
#   HOMEBREW_NO_AUTO_UPDATE
#   HOMEBREW_NO_GITHUB_API
#######################################################################
function bashrc::homebrew::configure()
{
  local config_home="${HOME}/.config"
  if [[ "${XDG_CONFIG_HOME:-}" != "" ]]; then
    config_home="${XDG_CONFIG_HOME}"
  fi

  local cache_home="${HOME}/.cache"
  if [[ "${XDG_CACHE_HOME:-}" != "" ]]; then
    cache_home="${XDG_CACHE_HOME}"
  fi

  # Automatically check for updates once per this seconds interval.
  if [[ "${HOMEBREW_AUTO_UPDATE_SECS:-}" == "" ]]; then
    local readonly ONE_HOUR_IN_SECONDS="3600"
    export HOMEBREW_AUTO_UPDATE_SECS="${ONE_HOUR_IN_SECONDS}"
  fi

  # If set $HOMEBREW_NO_AUTO_UPDATE to any value
  # except for an empty string,
  # do not automatically update before running
  # `brew install`, `brew upgrade` or `brew tap`.
  if [[ "${HOMEBREW_NO_AUTO_UPDATE:-}" == "" ]]; then
    export HOMEBREW_NO_AUTO_UPDATE="1"
  fi

  # If set $HOMEBREW_NO_ANALYTICS to any value
  # except for an empty string,
  # do not send analytics.
  #
  # @link https://docs.brew.sh/Analytics
  if [[ "${HOMEBREW_NO_ANALYTICS:-}" == "" ]]; then
    export HOMEBREW_NO_ANALYTICS="1"
  fi

  # If set $HOMEBREW_NO_GITHUB_API to any value
  # except for an empty string,
  # do not use the GitHub API.
  #
  # - e.g. for searches or fetching relevant issues
  #   after a failed install.
  if [[ "${HOMEBREW_NO_GITHUB_API:-}" == "" ]]; then
    export HOMEBREW_NO_GITHUB_API="1"
  fi

  # Append these options to all `cask` commands.
  if [[ "${HOMEBREW_CASK_OPTS:-}" == "" ]]; then
    export HOMEBREW_CASK_OPTS="--appdir='/Applications' --fontdir='/Library/Fonts'"
  fi

  # If set,
  # `brew install`, `brew upgrade` and `brew reinstall`
  # will cleanup all formulae when this number of days has passed.
  #
  # - Defaults: 30.
  if [[ "${HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS:-}" == "" ]]; then
    export HOMEBREW_CLEANUP_PERIODIC_FULL_DAYS="30"
  fi

  # Cleanup all cached files older than this many days.
  #
  # - Defaults: 120.
  if [[ "${HOMEBREW_CLEANUP_MAX_AGE_DAYS:-}" == "" ]]; then
    export HOMEBREW_CLEANUP_MAX_AGE_DAYS="45"
  fi

  # Use the specified directory as the download cache.
  #
  # - Defaults:
  #   - macOS: `$HOME/Library/Caches/Homebrew`.
  #   - Linux: `$XDG_CACHE_HOME/Homebrew`
  #            or `$HOME/.cache/Homebrew`.
  if [[ "${HOMEBREW_CACHE:-}" == "" ]]; then
    export HOMEBREW_CACHE="${cache_home}/Homebrew"
  fi

  # Use this directory to store log files.

  # - Defaults:
  #   - macOS: `$HOME/Library/Logs/Homebrew`
  #   - Linux: `$XDG_CACHE_HOME/Homebrew/Logs`
  #             or `$HOME/.cache/Homebrew/Logs.`
  if [[ "${HOMEBREW_LOGS:-}" == "" ]]; then
    export HOMEBREW_LOGS="${HOMEBREW_CACHE}/Logs"
  fi

  # Output this many lines of output
  # on formula system failures.
  #
  # - Defaults: 15.
  if [[ "${HOMEBREW_FAIL_LOG_LINES:-}" ]]; then
    export HOMEBREW_FAIL_LOG_LINES="50"
  fi

  # If set $HOMEBREW_DISPLAY_INSTALL_TIMES,
  # print install times for each formula
  # at the end of the run.
  if [[ "${HOMEBREW_DISPLAY_INSTALL_TIMES:-}" == "" ]]; then
    export HOMEBREW_DISPLAY_INSTALL_TIMES="1"
  fi

  # If set $HOMEBREW_BAT to any value except for a empty string,
  # use `bat` for the `brew cat` command.
  if command -v "bat" > /dev/null 2>&1; then
    export HOMEBREW_BAT="1"
  else
    unset HOMEBREW_BAT
  fi

  # Use $HOMEBREW_BAT_CONFIG_PATH as the `bat` configuration file.
  if [[ "${HOMEBREW_BAT_CONFIG_PATH:-}" == "" ]]; then
    local bat_config="${config_home}/bat/config"
    if test -e "${bat_config}"; then
      export HOMEBREW_BAT_CONFIG_PATH="${bat_config}"
    fi
  fi
}

function bashrc::homebrew::main()
{
  bashrc::homebrew::configure
}

bashrc::homebrew::main

unset -f bashrc::homebrew::main
unset -f bashrc::homebrew::configure
unset -f bashrc::homebrew::export_shellenv_if_brew_installed
