#!bin/bash

set -uo pipefail

JOBFILE=$1

# Check if the directory in the jobfile is still the default, and update if necessary
CURRENT_DIR=$(pwd)
BENCHMARK_OUTPUT_DIR=${CURRENT_DIR}/benchmark_dir
DEFAULT_DIR=/path/to/parallel/filesystem/mount
if grep -q directory=${DEFAULT_DIR} ${JOBFILE}; then
    mkdir $BENCHMARK_OUTPUT_DIR
    sed -i "s|directory=${DEFAULT_DIR}|directory=${BENCHMARK_OUTPUT_DIR}|" "${JOBFILE}"
fi

# Run the file provided
fio "$JOBFILE" --output-format=json > benchmark_results.json

# Print path to benchmark output
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_FILE=${CURRENT_DIR}/benchmark_results_${TIMESTAMP}.json
echo "Benchmark results saved to: ${OUTPUT_FILE}"

# Unset the changed dir in jobfiles
sed -i "s|directory=${BENCHMARK_OUTPUT_DIR}|directory=${DEFAULT_DIR}|" "${JOBFILE}"

set +uo pipefail
