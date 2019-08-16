#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `ls` command.
function bashrc::configure_ls_command()
{
    # Constants for OS type
    local readonly OS_TYPE_FREEBSD="FreeBSD"
    local readonly OS_TYPE_LINUX="Linux"
    local readonly OS_TYPE_MACOS="Darwin"

    os_type=$(uname -s)
    # if coreutils installed on MacOS, use the Linux configurations.
    if [ "${os_type}" == "${OS_TYPE_MACOS}" ] && [ -d "/usr/local/opt/coreutils/libexec/gnubin/ls" ]; then
        # For coreutils installed...
        os_type="${OS_TYPE_LINUX}"
    fi

    # Aliases
    # List directory contents with colorized output.
    #   -G        | Enable colorized output.
    #   -F        | Display a slash ('/') immediately after each pathname that is a directory,
    #             | an asterisk ('*') after each that is executable,
    #             | an at sign ('@') after each symbolic link,
    #             | an equals sign ('=') after each socket,
    #             | a percent sign ('%') after each whiteout,
    #             | and a vertical bar ('|') after each that is a FIFO.
    #   -d        | Directories are listed as plain files (not searched recursively).
    #   -1        | Force output to be one entry per line.
    #   -A        | Include directory entries whose names begin with a dot ('.').
    #   -l        | List files in the long format.
    #   -D format | When printing in the long (-l) format, use format to format the date and time output.
    case "${os_type}" in
        "${OS_TYPE_MACOS}" | \
        "${OS_TYPE_FREEBSD}")
            # FIXME FreeBSD not support `ls -D` argument
            alias ls="ls -GF"                                    # List files with colorized output.
            alias la="ls -GFA"                                   # List all files.
            alias l.="la -d .*"                                  # List hidden files only.
            alias l1="ls -GF1"                                   # Force output to be one entry per line.
            alias ll="ls -GFl -D '%Y-%m-%d %T'"                  # List files in the long format.
            alias lla="ll -a"                                    # List all files in the long format.
            alias ll.="ll -ad .*"                                # List hidden files in the long format.
            ;;
        "${OS_TYPE_LINUX}")
            alias ls="ls --color=auto -F"                         # List files with colorized output.
            alias l.="ls -ad .*"                                  # List hidden files only.
            alias l1="ls -1"                                      # Force output to be one entry per line.
            alias la="ls -a"                                      # List all files.
            alias ll="ls -l --time-style '+%Y-%m-%dT%H:%M:%S%:z'" # List files in the long format.
            alias lla="ll -a"                                     # List all files in the long format.
            alias ll.="ll -ad .*"                                 # List hidden files in the long format.
            ;;
    esac

    # Environment variables
    #   BLOCKSIZE | The block size in bytes by the -l and -s options.
    #   CLICOLOR  | Use ANSI color sequences to distinguish file types.
    #   LSCOLORS  | Describes what color to use for which attribute when colors are enabled with CLICOLOR,
    #             | the origin setting of LSCOLORS is "Dxfxcxdxbxegedabagacad".
    export BLOCKSIZE="K"
    export CLICOLOR=1

    case "${os_type}" in
        "${OS_TYPE_MACOS}" | \
        "${OS_TYPE_FREEBSD}")
            export LSCOLORS="ExfxcxdxbxEgEdabagacad"
            ;;
        "${OS_TYPE_LINUX}")
            # TODO Survey the LSCOLORS usage on Linux
            ;;
    esac
}

bashrc::configure_ls_command
