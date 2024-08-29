#!bin/bash

set -uo pipefail

# Check if autoconf and pkg-config are installed, else install them
if ! command -v autoconf &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y autoconf
fi
if ! command -v pkg-config &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y pkg-config
fi

# Clone the io500 repo and enter it
git clone https://github.com/IO500/io500.git
cd io500

# Run the prepare script
./prepare.sh

cd - > /dev/null

set +uo pipefail
