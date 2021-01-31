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

The module names that could be benchmarked:
* load (DONE)
* store (DONE)
* ntstore (DONE)
* copy (DONE)
* memcpy (DOING)
* pc (DOING)
* reduc (DONE)
* dp (dotprod) (TODO)
* triad (TODO)


The TODO list:
* memcpy :
	* Drawing the benchmark plot
* pc :
	* Drawing the benchmark plot
* dotprod :
	* Adding the bash function
	* Running the benchmark
	* Drawing the benchmark plot
* triad :
	* Adding the bash function
	* Running the benchmark
	* Drawing the benchmark plot


>**WARNING**: YOU MUST RUN EVERY BENCHMARK USING ROOT PRIVILEGES!!
