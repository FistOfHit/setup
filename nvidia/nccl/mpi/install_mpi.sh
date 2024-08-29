#!/bin/bash

sudo apt install mpich

# Compile and run test
mpicc -o mpi_test mpi_test.c
mpirun -np 4 ./mpi_test
