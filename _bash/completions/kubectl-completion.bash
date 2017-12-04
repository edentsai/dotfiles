#!/bin/bash

# Only source the completion when kubectl installed
if command -v kubectl &> /dev/null; then
    # Reference: https://github.com/kubernetes/minikube/issues/844#issuecomment-262587570
    tmp_file=$HOME/.bash/completions/kubectl-completion-tmp-$$.bash
    kubectl completion bash > $tmp_file
    source $tmp_file
    rm $tmp_file
fi
