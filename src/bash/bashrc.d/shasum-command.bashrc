#!/usr/bin/env bash
# vim: set filetype=sh

# Bashrc configuration for `shasum` command.
function bashrc::configure_shasum_command()
{
    # Return if shasum not installed
    if ! command -v shasum > /dev/null; then
        return
    fi

    # Add sha*sum aliases if the following commnads are not exists:
    # - sha1sum
    # - sha224sum
    # - sha256sum
    # - sha384sum
    # - sha512sum
    if ! command -v sha1sum > /dev/null; then
        alias sha1sum="shasum --algorithm 1"
    fi

    if ! command -v sha224sum > /dev/null; then
        alias sha1sum="shasum --algorithm 224"
    fi

    if ! command -v sha256sum > /dev/null; then
        alias sha1sum="shasum --algorithm 256"
    fi

    if ! command -v sha384sum > /dev/null; then
        alias sha1sum="shasum --algorithm 384"
    fi

    if ! command -v sha512sum > /dev/null; then
        alias sha1sum="shasum --algorithm 512"
    fi
}

bashrc::configure_shasum_command
