#!/usr/bin/env bash
# vim: set filetype=sh

set -o nounset -o errexit -o pipefail

# Only run on MacOS
os_type=$(uname -s)
os_type_macos="Darwin"
if [ "${os_type}" != "${os_type_macos}" ]; then
    return
fi
unset os_type
unset os_type_macos

# Add "homebrew/bundle" if not installed
if ! brew tap | grep -o "homebrew/bundle" > /dev/null; then
    brew tap "homebrew/bundle"
fi

brew bundle install --verbose --file=Brewfile
