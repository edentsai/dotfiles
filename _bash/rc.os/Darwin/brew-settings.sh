#!/usr/bin/env bash
# vim: set filetype=sh
#
# Homebrew settings for installed package.
#

# Specify your defaults in this environment variable
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# If you really need to use these commands with their normal names, you
# can add a "gnubin" directory to your PATH from your bashrc like:
unshift_paths_to_global "/usr/local/opt/coreutils/libexec/gnubin"

# Additionally, you can access their man pages with normal names if you add
# the "gnuman" directory to your MANPATH from your bashrc as well:
unshift_manpaths_to_global "/usr/local/opt/coreutils/libexec/gnuman"

# Source completions
source_file_if_exists "$(brew --prefix)/etc/bash_completion"
