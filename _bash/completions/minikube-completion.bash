#!/bin/bash

# Only source the completion when minikube installed
if command -v minikube &> /dev/null; then
    source <(minikube completion bash)
fi
