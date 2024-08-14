# DCPerf benchmarks

Installation and benchmarking scripts for Meta's DCPerf benchmark suite

## Includes

- `install.sh` - Installing DCPerf and all the benchmarks
- `benchmark.sh` - Run all the DCPerf benchmarks and generate the performance report

## Notes

- During the install step, you may see an error like: `/commands/python3: line 37: : command not found`. This is an issue with the local python install or how the script is being run, to possibly fix this, just re-run these steps manually with sudo.

## Following these sources

- [DCPerf github](https://github.com/facebookresearch/DCPerf)
- [DCPerf blogpost](https://engineering.fb.com/2024/08/05/data-center-engineering/dcperf-open-source-benchmark-suite-for-hyperscale-compute-applications/)
