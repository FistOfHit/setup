#!/bin/bash

# The following are some examples on how to use DGCM for monitoring and
# management of GPUs. This script is not meant to be run as a whole, but
# rather to be used as a reference for how to use DGCM in your own scripts.

# Capture job GPU statistics
# --group is the constructed group's ID, as made by DGCM earlier 
dcgmi stats --group 0 --enable

# Topology
dcgmi topo --group 0

# Show NVLink status
dcgmi nvlink --link-status

# Quick system validation - r goes from 1 to 4
dcgmi diag --group 0 -r 1 -p diagnostic.test_duration=7000 -v -j --fail-early
