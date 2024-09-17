#!/bin/bash

set -uo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi


echo "Benchmark complete"

set +uo pipefail
