# Measuring/Evaluating the performance of a computer system using benchmarks

## 1. Execution of the benchmark
### 1.1. Adding execution permission to the bash script
```bash
sudo chmod +x run_benchmarks.sh
```
### 1.2. Ways of execution of benchmarks
Execution of all benchmarks:
```bash
sudo ./run_benchmarks.sh all
```

Execution of 'load' benchmark:
```bash
sudo ./run_benchmarks.sh load
```

Execution of 'load' and 'store' benchmarks:
```bash
sudo ./run_benchmarks.sh load store
```

## 2. Available benchmarks
The module names that could be benchmarked:
* load (DONE)
* store (DONE)
* ntstore (DONE)
* copy (DONE)
* memcpy (DOING)
* pc (DOING)
* reduc (DONE)
* dp (dotprod) (DONE)
* triad (DONE)


## 3. TODO List
The TODO list:
* memcpy :
	* Drawing the benchmark plot
* pc :
	* Drawing the benchmark plot


>**WARNING**: YOU MUST RUN EVERY BENCHMARK USING ROOT PRIVILEGES!!
