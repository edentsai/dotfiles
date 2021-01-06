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

function bashrc::ls_command::main()
{
  bashrc::ls_command::configure_colors_for_freebsd
}

bashrc::ls_command::main

unset -f bashrc::ls_command::main
unset -f bashrc::ls_command::configure_colors_for_freebsd
