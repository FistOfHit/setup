#!bin/bash

set -euo pipefail

if ! dpkg -s libaio-dev &> /dev/null; then
    sudo apt-get install -y libaio-dev
fi

# Clone the FIO repo and enter it
git clone https://github.com/axboe/fio.git
cd fio

# Run the configure and install steps
sudo ./configure
sudo make
sudo make install

cd - > /dev/null
