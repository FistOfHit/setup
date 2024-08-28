#!bin/bash

set -euo pipefail

cd io500

./io500 config.ini

cd - > /dev/null
