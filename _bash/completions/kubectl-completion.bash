#!/bin/bash

# Only source the completion when kubectl installed
if command -v kubectl &> /dev/null; then
    source <(kubectl completion bash)
fi
