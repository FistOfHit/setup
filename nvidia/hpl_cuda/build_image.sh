#!/bin/bash

set -uo pipefail

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

docker build --no-cache -t hpc_benchmarks .

set +uo pipefail
