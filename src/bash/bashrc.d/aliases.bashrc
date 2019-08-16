#!/usr/bin/env bash
# vim: set filetype=sh

# Shorten commands.
alias c="clear"
alias cls="clear"
alias d="dir"
alias f="finger"
alias h="history"
alias l="last"
alias lo="logout"
alias um="unmount"
alias s="screen"
alias so="source"
alias t="telnet"
alias cps="composer"
alias gc="gcloud"
alias gcc="gcloud compute"
alias kc="kubectl"

# Be careful with copy files.
#   -i | Cause cp to write a prompt to the standard error output befor copying a file
#      | that would overwrite an existing file.
alias copy="cp -i"

# Be careful with move and rename files.
#   -i | Cause mv to write a prompt to standard error before moving a file
#      | that would overwrite an existing file.
alias move="mv -i"

# Be careful with remove files
#   -i | Request confirmation before attempting to remove each file.
alias remove="rm -i"

# Create parent directories on demand.
#   -p | Create intermediate directories as required.
#   -v | Be verbose when creating directories, listing them as they are created.
alias mkdir="mkdir -pv"
alias md="mkdir -pv"

# Display free disk space with Human-readable output.
#   -h | 'Human-readable' output.
alias df="df -h"

# Display disk usage statistics with Human-readable output.
#   -c | Display a grand total.
#   -h | 'Human-readable' output.
alias du='du -ch'

# Make mount command output pretty and human readable format
alias mount="mount | column -t"
alias m="mount"

# List jobs with more information.
alias jobs="jobs -l"
alias j="jobs -l"

# Do not verify the peer certificate against trusted CAs.
alias fetch="fetch --no-verify-peer"

# Start calculator with math support.
#   -l, --mathlib | Allow specification of an arbitrary precision math library.
alias bc="bc --mathlib"

# Colorize the tree command output.
alias tree="tree -CFl --dirsfirst"

# Tmux force to assume the terminal supports 256 colours.
alias tmux="tmux -2"

# Continue getting a partially-downloaded file.
alias wget="wget -c"

# Forces OpenSSH client to use IPv4 addresses only.
#   -4             | Force to use IPv4 addresses only.
#   -6             | Force to use IPv6 addresses only.
#   -C             | Request compression of all data.
#   -e escape_char | Sets the escape character for sessions with a pty (default: '~'),
#                  | Setting the character to “none” disables any escapes and makes the session fully transparent .
#   -v             | Enables verbose mode.
alias ssh="ssh -4 -C -e none"

# PHPUnit always use colors in output.
alias phpunit="phpunit --colors"

# Quickly go back to a specific parent directory
alias bd=". bd -s"

# icdiff always display line numbers.
alias icdiff="icdiff --line-numbers"

# Display information about my top cpu processes
alias topme="top -U $USER"

# httping always use colors.
alias httping="httping --colors"

# List $PATH and force output to be one entry per line
alias path="echo -e \${PATH//:/\\\n}"

# List $MANPATH and force output to be one entry per line
alias manpath="echo -e \${MANPATH//:/\\\n}"

# Display today's date.
alias today="date '+%Y-%m-%d %T'"

# The ping command do not wait interval 1 second, go fast
#   -c count      | Stop after sending (and receiving) count ECHO_RESPONSE packets.
#   -s packetsize | Specify the number of data bytes to be sent.
alias fastping='ping -c 100 -s.2'
