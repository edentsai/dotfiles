#!/bin/bash

# Only source the completion when minikube installed
if command -v minikube &> /dev/null; then
    has_minikube=1
    source <(minikube completion bash)
fi
