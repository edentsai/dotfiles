#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure env variables and aliases for `ls` command by os name
bashrc::configure_ls_command_by_os_name()
{
    # Constants for OS name
    local readonly OS_NAME_DARWIN="Darwin"
    local readonly OS_NAME_FREEBSD="FreeBSD"
    local readonly OS_NAME_LINUX="Linux"
    local readonly OS_NAME_MACOS="${OS_NAME_DARWIN}"

    local readonly os_name="${1}"

    # if GNU coreutils is installed on MacOS, use the Linux configurations.
    if [[ "${os_name}" == "${OS_NAME_MACOS}" ]] && [[ -d "/usr/local/opt/coreutils/libexec/gnubin/ls" ]]; then
        # For coreutils installed...
        os_name="${OS_NAME_LINUX}"
    fi

    # Environment variables.
    #   BLOCKSIZE    | The block size in bytes by the -l and -s options.
    #   CLICOLOR     | Use ANSI color sequences to distinguish file types.
    #   LSCOLORS     | Describes what color to use for which attribute when colors are enabled with CLICOLOR,
    #                | the origin setting of LSCOLORS is "exfxcxdxbxegedabagacad".
    export BLOCKSIZE="K"
    export CLICOLOR=1

    case "${os_name}" in
        "${OS_NAME_DARWIN}" | "${OS_NAME_MACOS}")
            export LSCOLORS="ExfxcxdxbxEgEdabagacad"
            ;;
        "${OS_NAME_FREEBSD}")
            # TODO Survey the LSCOLORS usage on FreeBSD
            ;;
        "${OS_NAME_LINUX}")
            # TODO Survey the LSCOLORS usage on Linux
            ;;
    esac

    # Aliases for list directory contents with colorized output.
    #   --color=auto | Auto enable colorized output. (Linux supported only)
    #   -G           | Enable colorized output. (MacOS supported only)
    #   -F           | Display a slash ('/') immediately after each pathname that is a directory,
    #                | an asterisk ('*') after each that is executable,
    #                | an at sign ('@') after each symbolic link,
    #                | an equals sign ('=') after each socket,
    #                | a percent sign ('%') after each whiteout,
    #                | and a vertical bar ('|') after each that is a FIFO.
    #   -1           | Force output to be one entry per line.
    #   -A           | Include directory entries whose names begin with a dot ('.').
    #   -d           | Directories are listed as plain files (not searched recursively).
    #   -l           | List files in the long format.
    #   --full-time  | List full date and time (Linux supported only)
    #   -T           | List full date and time (MacOS supported only)
    case "${os_name}" in
        "${OS_NAME_DARWIN}" | "${OS_NAME_MACOS}")
            alias ls="ls -GF"                   # List files with colorized output.
            alias l1="ls -1"                    # Force output to be one entry per line.

            alias la="ls -A"                    # List all files
            alias l.="ls -Ad .*"                # List hidden files only.

            alias ll="ls  -lT"                   # List files in the long format.
            alias lla="ls -lTA"                 # List all files in the long format.
            alias ll.="ls -lTAd .*"             # List hidden files in the long format.
            ;;
        "${OS_NAME_FREEBSD}")
            # TODO Survey ls command on FreeBSD
            ;;
        "${OS_NAME_LINUX}")
            alias ls="ls --color=auto -F"       # List files with colorized output.
            alias l1="ls -1"                    # Force output to be one entry per line.

            alias la="ls -A"                    # List all files.
            alias l.="ls -Ad .*"                # List hidden files only.

            alias ll="ls  --full-time -l"       # List files in the long format with full time.
            alias lla="ls --full-time -lA"      # List all files in the long format.
            alias ll.="ls --full-time -lAd .*"  # List hidden files in the long format.
            ;;
    esac
}

bashrc::configure_ls_command_by_os_name "$(uname -s)"
