#!/bin/bash

# Additional args needed for AMD GPUs and RCCL
docker run \
    --network=host \
    --device=/dev/kfd \
    --device=/dev/dri \
    --group-add video \
    --cap-add=SYS_PTRACE \
    --security-opt seccomp=unconfined \
    -it \
    --rm \
    --ipc=host \
    --shm-size 192G \
    -v $(pwd)/results:/workspace/results \
    semianalysiswork/clustermax-rccl
