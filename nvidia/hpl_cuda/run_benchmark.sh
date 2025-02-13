#!/bin/bash

# INTENDED TO BE RUN FROM WITHIN THE CONTAINER

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Check for required commands
command -v nvidia-smi >/dev/null 2>&1 || { echo >&2 "nvidia-smi is required but it's not installed. Aborting."; exit 1; }
command -v docker --version >/dev/null 2>&1 || { echo >&2 "docker is required but it's not installed. Aborting."; exit 1; }
command -v mpirun --version >/dev/null 2>&1 || { echo >&2 "mpirun is required but it's not installed. Aborting."; exit 1; }

# Parameters
GPU_COUNT=$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | wc -l)
DAT_FILE="./custom_HPL-${GPU_COUNT}GPU.dat"
TIMEOUT_DURATION="1h"
DOCKER_IMAGE="hpc_benchmarks"

# Check if the data file exists
if [ ! -f "${DAT_FILE}" ]; then
  echo "Data file ${DAT_FILE} not found. Aborting."
  exit 1
fi

# Timed for 1 hour cycles in datacenter burn tests
LOG_FILE="hpl_benchmark_$(date +%Y%m%d_%H%M%S).log"
timeout ${TIMEOUT_DURATION} docker run \
  --rm \
  --gpus all \
  --privileged \
  --shm-size=64g \
  --ipc=host \
  --ulimit memlock=-1 \
  --ulimit stack=67108864 \
  ${DOCKER_IMAGE} \
  mpirun --bind-to none -np ${GPU_COUNT} ./hpl.sh --dat ${DAT_FILE} \
  > >(tee -a "${LOG_FILE}") 2>&1

echo "Benchmark output saved to ${LOG_FILE}"

if [ $? -eq 124 ]; then
  echo "Benchmark terminated after reaching ${TIMEOUT_DURATION} time limit."
fi

set +euo pipefail
