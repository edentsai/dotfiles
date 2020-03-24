#!/usr/bin/env bash
# vim: set filetype=sh

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
    return
fi

# Configure aliases for shasum command.
bashrc::configure_shasum_command()
{
    # Return if shasum not installed
    if ! command -v "shasum" > /dev/null 2>&1; then
        return
    fi

    # Add sha*sum aliases if the following commnads are not exists:
    # - sha1sum
    # - sha224sum
    # - sha256sum
    # - sha384sum
    # - sha512sum
    if ! command -v "sha1sum" > /dev/null 2>&1; then
        alias sha1sum="shasum --algorithm 1"
    fi

    if ! command -v "sha224sum" > /dev/null 2>&1; then
        alias sha224sum="shasum --algorithm 224"
    fi

    if ! command -v "sha256sum" > /dev/null 2>&1; then
        alias sha256sum="shasum --algorithm 256"
    fi

    if ! command -v "sha384sum" > /dev/null 2>&1; then
        alias sha384sum="shasum --algorithm 384"
    fi

    if ! command -v "sha512sum" > /dev/null 2>&1; then
        alias sha512sum="shasum --algorithm 512"
    fi
}

bashrc::configure_shasum_command
