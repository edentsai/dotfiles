#!/usr/bin/env bash

# Bash Completion Configuration.
#
# NOTE:
#
# - Completion of valid paths involving variables adds backslashes.
#   https://github.com/scop/bash-completion/issues/290
#
# @link https://github.com/scop/bash-completion
# @link https://github.com/scop/bash-completion#faq
# @link https://github.com/scop/bash-completion/blob/master/doc/bash_completion.txt
# @link https://github.com/scop/bash-completion/blob/master/bash_completion.sh.in

# Return if not running interactive bash.
if [[ "${BASH_VERSION:-}" == "" ]] || [[ "${PS1:-}" == "" ]]; then
  return
fi
