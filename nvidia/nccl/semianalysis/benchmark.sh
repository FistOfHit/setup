#!/bin/bash

# Run the docker container with the following command
docker run --gpus all --ipc=host --shm-size 192G -v $(pwd)/results:/workspace/results semianalysiswork/clustermax-nccl
