#!bin/bash

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check Ubuntu version
if [ ! -f /etc/os-release ]; then
    echo "Cannot detect OS. Please install manually."
    exit 1
fi

. /etc/os-release
if [ "$NAME" != "Ubuntu" ] || [ "$VERSION_ID" != "22.04" ]; then
    echo "This script is for Ubuntu 22.04 only."
    exit 1
fi

# Install prerequisites
apt update
apt install -y python3-pip git lshw
python3 -m pip install click pyyaml tabulate pandas

# Clone DCPerf repository
git clone https://github.com/facebookresearch/DCPerf.git
cd DCPerf

# Set ulimit
ulimit -n 65536
echo "* soft nofile 65536" >> /etc/security/limits.conf
echo "* hard nofile 65536" >> /etc/security/limits.conf

# Install DCPerf benchmarks
./benchpress_cli.py install tao_bench_autoscale
./benchpress_cli.py install feedsim_default
./benchpress_cli.py install oss_performance_mediawiki_mlp
./benchpress_cli.py install django_workload_default
./benchpress_cli.py install spark_standalone

echo "DCPerf installation complete. Please refer to the individual benchmark READMEs for specific configuration and execution instructions."
