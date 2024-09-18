#!/bin/bash

set -uo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

RUN_PATH=hpl/bin/linux

cp config_files/test.dat $RUN_PATH/HPL.dat
./${RUN_PATH}/xhpl

echo "Test benchmark complete"

set +uo pipefail
