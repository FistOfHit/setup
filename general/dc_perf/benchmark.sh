#!/bin/bash

set -euo pipefail

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit 1
fi

# Change to DCPerf directory
cd DCPerf || { echo "DCPerf directory not found. Please install DCPerf first."; exit 1; }

# Function to run a benchmark
run_benchmark() {
    local benchmark=$1
    echo "Running $benchmark..."
    ./benchpress_cli.py run "$benchmark"
    echo "$benchmark completed."
    echo
}

# Function to enable performance monitoring
enable_perf_monitoring() {
    local benchmark=$1
    echo "Enabling performance monitoring for $benchmark..."
    sed -i "/hooks/a\    - hook: perf\n      options:\n        interval: 1\n        events: ['cycles', 'instructions', 'cache-misses', 'cache-references']\n        output: perf_${benchmark}.json" "jobs/$benchmark.yml"
}

# Run benchmarks
benchmarks=(
    "tao_bench_autoscale"
    "feedsim"
    "oss_performance_mediawiki"
    "django_workload_default"
    "spark_standalone"
)

for benchmark in "${benchmarks[@]}"; do
    enable_perf_monitoring "$benchmark"
    run_benchmark "$benchmark"
done

# Generate DCPerf score report
echo "Generating DCPerf score report..."
./benchpress_cli.py report score --all > dcperf_score_report.txt

# Generate detailed performance report
echo "Generating detailed performance report..."
{
    echo "DCPerf Detailed Performance Report"
    echo "=================================="
    echo
    echo "DCPerf Score:"
    cat dcperf_score_report.txt
    echo
    echo "Individual Benchmark Results:"
    echo "-----------------------------"
    for benchmark in "${benchmarks[@]}"; do
        echo
        echo "$benchmark Results:"
        jq . "benchmark_metrics_$(ls -t benchmark_metrics_* | head -n1)/${benchmark}_metrics_"*".json"
        echo
        echo "$benchmark Performance Metrics:"
        jq . "perf_${benchmark}.json"
    done
} > dcperf_detailed_report.txt

echo "DCPerf benchmarks completed. Detailed report saved in dcperf_detailed_report.txt"
