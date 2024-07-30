#!/bin/bash

NVBANDWIDTH_DIR="./nvbandwidth"

run_benchmark() {
    local benchmark_name="$1"
    local benchmark_command="$2"
    
    echo "\tRunning benchmark: $benchmark_name"
    if ! $benchmark_command; then
        echo "\tError: Benchmark '$benchmark_name' failed." >&2
        return 1
    fi
    echo "\tBenchmark '$benchmark_name' completed successfully."
    echo
}

main() {
    # Check if nvbandwidth directory exists
    if [[ ! -d "$NVBANDWIDTH_DIR" ]]; then
        echo "Error: Directory '$NVBANDWIDTH_DIR' not found." >&2
        echo "Please ensure you're in the correct directory and nvbandwidth is installed." >&2
        exit 1
    fi

    # Change to nvbandwidth directory
    cd "$NVBANDWIDTH_DIR" || exit 1

    echo "device to device"
    run_benchmark "device -> device: Unidirectional read" "./nvbandwidth -t device_to_device_memcpy_read_sm"
    run_benchmark "device -> device: Unidirectional write" "./nvbandwidth -t device_to_device_memcpy_write_sm"
    run_benchmark "device <-> device: Bidirectional read" "./nvbandwidth -t device_to_device_bidirectional_memcpy_read_sm"
    run_benchmark "device <-> device: Bidirectional write" "./nvbandwidth -t device_to_device_bidirectional_memcpy_write_sm"

    echo "host to device"
    run_benchmark "host -> device" "./nvbandwidth -t host_to_device_memcpy_sm"
    run_benchmark "host -> device" "./nvbandwidth -t device_to_host_memcpy_sm"
 
    echo "all to host"
    run_benchmark "all -> host: Unidirectional read" "./nvbandwidth -t all_to_host_memcpy_sm"
    run_benchmark "all <-> host: Bidirectional read" "./nvbandwidth -t all_to_host_bidirectional_memcpy_sm"

    echo "host to all"
    run_benchmark "host -> all: Unidirectional write" "./nvbandwidth -t host_to_all_memcpy_sm"
    run_benchmark "host <-> all: Bidirectional write" "./nvbandwidth -t host_to_all_bidirectional_memcpy_sm"

    echo "all to one"
    run_benchmark "all -> one: read" "./nvbandwidth -t all_to_one_read_sm"
    run_benchmark "all -> one: write" "./nvbandwidth -t all_to_one_write_sm"

    echo "one to all"
    run_benchmark "one -> all read" "./nvbandwidth -t one_to_all_read_sm"
    run_benchmark "one -> all write" "./nvbandwidth -t one_to_all_write_sm"

    echo "Latency"
    run_benchmark "Host -> Device" "./nvbandwidth -t host_device_latency_sm"
    run_benchmark "Device -> Device" "./nvbandwidth -t device_to_device_latency_sm"

    # Return to original directory
    cd - > /dev/null
}

main

exit 0
