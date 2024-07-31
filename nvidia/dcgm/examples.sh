#!/bin/bash

# The following are some examples on how to use DGCM for monitoring and
# management of GPUs. This script is not meant to be run as a whole, but
# rather to be used as a reference for how to use DGCM in your own scripts.


# Capture job GPU statistics
# --group is the constructed group's ID, as made by DGCM earlier 
dcgmi stats --group 1 --enable
# ... job runs ...
# Print captured stats
dcgmi stats --pid 1234 -v


# Full system validation
dcgmi diag --group 1 -r 3


# Topology
dcgmi topo ---group 1


# Show NVLink errors
dcgmi nvlink --errors --group 0


# Show NVLink status
dcgmi nvlink --link-status
