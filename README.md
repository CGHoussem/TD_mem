# Measuring/Evaluating the performance of a computer system using benchmarks

## Execution of the benchmark
Execution of all benchmarks:
```bash
sudo sh run_benchmarks.sh all
```

Execution of 'load' benchmark:
```bash
sudo sh run_benchmarks.sh load
```
Execution of 'load' and 'store' benchmarks:
```bash
sudo sh run_benchmarks.sh load store
```

The modules that could be benchmarked:
* load
* store
* ntstore
* copy
* memcpy
* pc
* reduc
* dp (dotprod)
* triad

>**WARNING**: YOU MUST HAVE ROOT PRIVILEGES!!
