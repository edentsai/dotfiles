#!/bin/bash

# Only source the completion when minikube installed
if command -v minikube &> /dev/null; then
    # Reference: https://github.com/kubernetes/minikube/issues/844#issuecomment-262587570
    tmp_file=$HOME/.bash/completions/minikube-completion-tmp-$$.bash
    minikube completion bash > $tmp_file
    source $tmp_file
    rm $tmp_file
fi
