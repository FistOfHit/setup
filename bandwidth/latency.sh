#!/bin/bash

# Set strict mode
set -euo pipefail

# Define the directory where nvbandwidth is located
NVBANDWIDTH_DIR="./nvbandwidth"

# Function to run a benchmark
run_benchmark() {
    local benchmark_name="$1"
    local benchmark_command="$2"
    
    echo "Running benchmark: $benchmark_name"
    if ! $benchmark_command; then
        echo "Error: Benchmark '$benchmark_name' failed." >&2
        return 1
    fi
    echo "Benchmark '$benchmark_name' completed successfully."
    echo
}

# Main function
main() {
    # Check if nvbandwidth directory exists
    if [[ ! -d "$NVBANDWIDTH_DIR" ]]; then
        echo "Error: Directory '$NVBANDWIDTH_DIR' not found." >&2
        echo "Please ensure you're in the correct directory and nvbandwidth is installed." >&2
        exit 1
    fi

    # Change to nvbandwidth directory
    cd "$NVBANDWIDTH_DIR" || exit 1

    # Run benchmarks
    run_benchmark "Host -> Device" "./nvbandwidth -t host_device_latency_sm"
    run_benchmark "Device -> Device" "./nvbandwidth -t device_to_device_latency_sm"

    # Return to original directory
    cd - > /dev/null
}

# Run the main function
main

exit 0
