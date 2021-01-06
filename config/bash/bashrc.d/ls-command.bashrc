#!/usr/bin/env bash

# Bash configuration for the `ls` command.
#
# @link https://www.gnu.org/software/bash/manual/bash.html#Bourne-Shell-Variables

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

#######################################################################
# Configure `$CLICOLOR` and `$LSCOLORS` variables for FreeBSD.
#
# @link https://geoff.greer.fm/lscolors
#
# Globals:
#   CLICOLOR
#   LSCOLORS
#######################################################################
function bashrc::ls_command::configure_colors_for_freebsd()
{
  # Use ANSI color sequences to distinguish file types.
  if [[ "${CLICOLOR:-}" == "" ]]; then
    export CLICOLOR="1"
  fi

  # The value of this variable describes what color to use
  # for which attribute when colors are enabled with $CLICOLOR.
  #
  # The color designators are as follows:
  #
  #   a     black
  #   b     red
  #   c     green
  #   d     brown
  #   e     blue
  #   f     magenta
  #   g     cyan
  #   h     light grey
  #   A     bold black, usually shows up as dark grey
  #   B     bold red
  #   C     bold green
  #   D     bold brown, usually shows up as yellow
  #   E     bold blue
  #   F     bold magenta
  #   G     bold cyan
  #   H     bold light grey; looks like bright white
  #   x     default foreground or background
  #
  # Note that the above are standard ANSI colors.
  # The actual display may differ depending on the color
  # capabilities of the terminal in use.
  #
  # The order of the attributes are as follows:
  #
  #   1.   directory
  #   2.   symbolic link
  #   3.   socket
  #   4.   pipe
  #   5.   executable
  #   6.   block special
  #   7.   character special
  #   8.   executable with setuid bit set
  #   9.   executable with setgid bit set
  #   10.  directory writable to others, with sticky bit
  #   11.  directory writable to others, without sticky bit
  #
  # The default is "exfxcxdxbxegedabagacad",
  # for examples:
  #
  # - blue fore-ground and default background
  #   for regular directories,
  # - black foreground and red background
  #   for setuid executa-bles, etc.
  if [[ "${LSCOLORS:-}" == "" ]]; then
    export LSCOLORS="ExgxcxdxBxegedabagacad"
  fi
}

#######################################################################
# Configure LS_COLORS for Linux with `dircolors`.
#
# @link https://www.gnu.org/software/coreutils/manual/html_node/dircolors-invocation.html
#
# Globals:
#   HOME
#   LS_COLORS
#   XDG_CONFIG_HOME
#######################################################################
function bashrc::ls_command::configure_colors_for_linux()
{
  local config_home="${HOME}/.config"
  if [[ "${XDG_CONFIG_HOME:-}" != "" ]]; then
    config_home="${XDG_CONFIG_HOME}"
  fi

  # Skip if LS_COLORS already configured.
  if [[ "${LS_COLORS:-}" != "" ]]; then
    return
  fi

  # Found the first dircolors file in the following paths:
  #
  # 1. `$HOME/.dircolors`
  # 2. `$XDG_CONFIG_HOME/dircolors/dircolors`
  local dircolors_file="${config_home}/dircolors/dircolors";
  if test -e "${HOME}/.dircolors"; then
    dircolors_file="${HOME}/.dircolors";
  elif test -e "${config_home}/dircolors/dircolors"; then
    dircolors_file="${config_home}/dircolors/dircolors"
  else
    return
  fi

  # Export LS_COLORS variable for Linux.
  if command -v "dircolors" > /dev/null 2>&1; then
    eval "$(dircolor --bourne-shell "${dircolors_file}")"

    return
  fi

  # Export LS_COLORS variable
  # when GNU coreutils installed on macOS.
  if command -v "gdircolors" > /dev/null 2>&1; then
    eval "$(gdircolors --bourne-shell "${dircolors_file}")"
  fi

  return
}

#######################################################################
# Define aliases for `ls` or `gls` commands in Bash.
#
# - Aliases for `ls` depends on macOS or Linux.
# - Alaises for `gls` when GNU coreutils installed on macOS.
#
# @link https://www.gnu.org/software/coreutils/manual/html_node/ls-invocation.html#ls-invocation
# @link https://www.gnu.org/software/coreutils/manual/html_node/General-output-formatting.html#General-output-formatting
#######################################################################
function bashrc::ls_command::define_aliases()
{
  local readonly OS_NAME_DARWIN="Darwin"
  local readonly OS_NAME_LINUX="Linux"
  local readonly OS_NAME_MACOS="${OS_NAME_DARWIN}"

  local os_name
  os_name="$(uname -s)"

  case "${os_name}" in
    "${OS_NAME_DARWIN}" | "${OS_NAME_MACOS}")
      # Options on FreeBSD / macOS:
      #
      # -1
      #   Force output to be one entry per line.
      #
      # -A
      #   List all entries except for "." and "..".
      #
      # -d
      #   Directories are listed as plain files
      #   (not searched recursively).
      #
      # -G
      #   Enable colorized output.
      #   (This option is equivalent to defining CLICOLOR in the environment.
      #
      # -F
      #   Display a slash (`/') immediately after each pathname
      #   that is a directory,
      #   an asterisk (`*') after each that is executable,
      #   an at sign (`@') after each symbolic link,
      #   an equals sign (`=') after each socket,
      #   a percent sign (`%') after each whiteout,
      #   and a vertical bar (`|') after each that is a FIFO.
      #
      # -l
      #   (The lowercase letter `ell`).
      #   List in long format. A total sum for all the file sizes
      #   is output on a line before the long listing.
      #
      # -h
      #   When used with the -l option (the lowercase letter `ell`),
      #   use unit suffixes: Byte, Kilobyte, Megabyte, Gigabyte,
      #   Terabyte and Petabyte in order to reduce the number
      #   of digits to three or less using base 2 for sizes.
      #
      # -T
      #   When used with the -l option (the lowercase letter `ell`),
      #   display complete time information for the file,
      #   including month, day, hour, minute, second, and year.

      # List files with colorized output and classify symbol.
      alias ls="ls -G -F"

      # List files in one entry per line.
      alias l1="ls -1"

      # List all files included hidden files.
      alias la="ls -A"

      # List hidden files only.
      alias l.="ls -A -d .*"

      # List files in the long format with completed information.
      alias ll="ls -l -h -T"

      # List all files in the long format with completed information.
      alias lla="ll -A"

      # List hidden files in the long format
      # with completion information.
      alias ll.="ll -A -d .*"
      ;;
    "${OS_NAME_LINUX}")
      # Options on Linux:
      #
      # -1
      #   List one file per line.
      #   Avoid '\n' with -q or -b
      #
      # -A, --almost-all
      #   do not ignore entries starting with ".",
      #   and do not list implied "." and "..".
      #
      # --color[=WHEN]
      #   Colorize the output;
      #   WHEN can be "always" (default if omitted), "auto", or "never".
      #
      # -d, --directory
      #   List directories themselves, not their contents.
      #
      # -F, --classify
      #   Append indicator (one of */=>@|) to entries.
      #
      # --group-directories-first
      #   Group directories before files;
      #
      # -l
      #   Use a long listing format.
      #
      # -h, --human-readable
      #   With -l and -s, print sizes like 1K 234M 2G etc.
      #
      # --si
      #   Likewise, but use powers of 1000 not 1024.
      #
      # --time-style=TIME_STYLE
      #   Time/date format with -l optoin,
      #   see TIME_STYLE in `man ls` for more details.
      #
      #     %b  locale's abbreviated month name (e.g., Jan).
      #     %e  day of month, space padded; same as "%_d".
      #     %H  hour (00..23).
      #     %M  minute (00..59).
      #     %Y  year.

      # List files with colorized output and classify symbol.
      alias ls="ls --color='auto' --classify"

      # List files in one entry per line.
      alias l1="ls -1"

      # List all files included hidden files.
      alias la="ls --almost-all"

      # List hidden files only.
      alias l.="ls --almost-all --directory .*"

      # List files in the long format with completed information,
      #
      # - Use same time style with FreeBsd `ls -l -h`,
      #   for example: "Jan  5 12:16 2021"
      alias ll="ls -l --human-readable --time-style='+%b %e %H:%M %Y'"

      # List all files in the long format with completed information.
      alias lla="ll --almost-all"

      # List hidden files in the long format
      # with completion information.
      alias ll.="ll --almost-all --directory .*"
      ;;
  esac

  # Aliases for `gls` command when GNU coreutils installed on macOS.
  if ! command -v "${prerequisite_command}" > /dev/null 2>&1; then
    alias gls="gls --color=auto --classify"
    alias gl1="gls -1"
    alias gla="gls --almost-all"
    alias gl.="gls --almost-all --directory .*"
    alias gll="gls -l --human-readable --time-style='+%b %e %H:%M %Y'"
    alias glla="gl --almost-all"
    alias gll.="gl --almost-all --directory .*"
  fi
}

function bashrc::ls_command::main()
{
  bashrc::ls_command::configure_colors_for_freebsd
  bashrc::ls_command::configure_colors_for_linux
  bashrc::ls_command::define_aliases
}

bashrc::ls_command::main

unset -f bashrc::ls_command::main
unset -f bashrc::ls_command::configure_colors_for_freebsd
unset -f bashrc::ls_command::configure_colors_for_linux
unset -f bashrc::ls_command::define_aliases
