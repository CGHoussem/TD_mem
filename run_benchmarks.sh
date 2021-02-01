#!/bin/bash
clear

# Stop NetworkManager
echo "Stopping NetworkManager.."
systemctl stop NetworkManager

# Gathering compilers versions
echo "Gathering compiler version.."
if [ ! -d "compilers" ]; then
	mkdir compilers
fi
gcc --version > compilers/gcc.txt
clang --version > compilers/clang.txt
ldd --version > compilers/glibc.txt

# Creating directories
echo "Gather system informations.."
if [ ! -d "system" ]; then
	mkdir system system/cpu system/caches system/memory
else
	if [ ! -d "system/cpu" ]; then
		mkdir system/cpu
	fi
	if [ ! -d "system/caches" ]; then
		mkdir system/caches
	fi
	if [ ! -d "system/memory" ]; then
		mkdir system/memory
	fi
fi

# Gathering all hardware information
dmidecode > system/hw.txt

# Populating the cpu directory
cat /proc/cpuinfo > system/cpu/info.txt
numactl -H > system/cpu/numactl.txt

# Populating the caches directory
cat /sys/devices/system/cpu/cpu*/cache/index*/* > system/caches/all.txt
lscpu | grep "cache" > system/caches/sizes.txt

# Populating the memory directory
cat /proc/meminfo > system/memory/info.txt

# Setting up CPU frequencies
echo "Setting cpu frequency to PERFORMANCE.."
cpupower frequency-set -g performance
# the line below is commented because the governor 'userspace' isn't available!
#cpupower frequency-set -f 3.4GHz

function load_benchmark() {
	# ==================================
	# ========= load benchmark =========
	# ==================================
	# Building the "load" benchmark binary
	cd load
	{
		make clean
		make
	} &> /dev/null
	# Running "load" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./load_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > load_L1.dat
	# Running "load" benchmark on 512 KiB of memory (fits in L2 cache)
	taskset -c 5 ./load_SSE_AVX $(( 512 * 2**M0 )) 1000 | cut -d';' -f1,8,9 > load_L2.dat
	# Running "load" benchmark on 2 MiB of memory (fits in L3 cache)
	taskset -c 6 ./load_SSE_AVX $(( 2 * 2**20 )) 1000 | cut -d';' -f1,8,9 > load_L3.dat
	# Running "load" benchmark on 8 MiB of memory (fits in DRAM)
	taskset -c 7 ./load_SSE_AVX $(( 8 * 2**20 )) 1000 | cut -d';' -f1,8,9 > load_DRAM.dat
	# Drawing the load benchmark plot
	cd ..
	gnuplot -c "plot_load_bw.gp" > load_bw.png
}

function store_benchmark() {
	# ==================================
	# ======== store benchmark =========
	# ==================================
	# Building the "store" benchmark binary
	cd store/
	{
		make clean
		make
	} &> /dev/null
	# Running "store" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./store_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > store_L1.dat
	# Running "store" benchmark on 512 KiB of memoy (fits in L2 cache)
	taskset -c 5 ./store_SSE_AVX $(( 512 * 2**10 )) 1000 | cut -d';' -f1,8,9 > store_L2.dat
	# Running "store" benchmark on 2 MiB of memoy (fits in L3 cache)
	taskset -c 6 ./store_SSE_AVX $(( 2 * 2**20 )) 1000 | cut -d';' -f1,8,9 > store_L3.dat
	# Running "store" benchmark on 8 MiB of memoy (fits in DRAM)
	taskset -c 7 ./store_SSE_AVX $(( 8 * 2**20 )) 1000 | cut -d';' -f1,8,9 > store_DRAM.dat
	# Drawing the store benchmark plot
	cd ..
	gnuplot -c "plot_store_bw.gp" > store_bw.png
}

function ntstore_benchmark() {
	# ==================================
	# ======= ntstore benchmark ========
	# ==================================
	# Building the "ntstore" benchmark binary
	cd ntstore/
	{
		make clean
		make
	} &> /dev/null
	# Running "ntstore" benchmark on 8 MiB of memoy
	taskset -c 6 ./ntstore_SSE_AVX $(( 8 * 2**20 )) 500 | cut -d';' -f1,8,9 > ntstore_DRAM_1.dat
	# Running "ntstore" benchmark on 16 MiB of memoy
	taskset -c 7 ./ntstore_SSE_AVX $(( 16 * 2**20 )) 500 | cut -d';' -f1,8,9 > ntstore_DRAM_2.dat
	# Drawing the ntstore benchmark plot
	cd ..
	gnuplot -c "plot_ntstore_bw.gp" > ntstore_bw.png
}

function copy_benchmark() {
	# ==================================
	# ======== copy benchmark =========
	# ==================================
	# Building the "copy" benchmark binary
	cd copy/
	{
		make clean
		make
	} &> /dev/null
	# Running "copy" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./copy_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > copy_L1.dat
	# Running "copy" benchmark on 512 KiB of memoy (fits in L2 cache)
	taskset -c 5 ./copy_SSE_AVX $(( 512 * 2**10 )) 1000 | cut -d';' -f1,8,9 > copy_L2.dat
	# Running "copy" benchmark on 2 MiB of memoy (fits in L3 cache)
	taskset -c 6 ./copy_SSE_AVX $(( 2 * 2**20 )) 500 | cut -d';' -f1,8,9 > copy_L3.dat
	# Running "copy" benchmark on 8 MiB of memoy (fits in DRAM)
	taskset -c 7 ./copy_SSE_AVX $(( 8 * 2**20 )) 500 | cut -d';' -f1,8,9 > copy_DRAM.dat
	# Drawing the copy benchmark plot
	cd ..
	gnuplot -c "plot_copy_bw.gp" > copy_bw.png
}

function memcpy_benchmark() {
	# ==================================
	# ======== memcpy benchmark ========
	# ==================================
	# Building the "memcpy" benchmark binary
	cd memcpy/
	{
		make clean
		make
	} &> /dev/null
	# Running "memcpy" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./memcpy $(( 64 * 2**10 )) 1000 > memcpy_L1.dat
	# Running "memcpy" benchmark on 512 KiB of memoy (fits in L2 cache)
	taskset -c 5 ./memcpy $(( 512 * 2**10 )) 1000 > memcpy_L2.dat
	# Running "memcpy" benchmark on 2 MiB of memoy (fits in L3 cache)
	taskset -c 6 ./memcpy $(( 2 * 2**20 )) 500 > memcpy_L3.dat
	# Running "memcpy" benchmark on 8 MiB of memoy (fits in DRAM)
	taskset -c 7 ./memcpy $(( 8 * 2**20 )) 500 > memcpy_DRAM.dat
	# TODO: Drawing the memcpy benchmark plot
	cd ..

}

function pc_benchmark() {
	# ==================================
	# ========== pc benchmark ==========
	# ==================================
	# Building the "pc" benchmark binary
	cd pc/
	{
		make clean
		make
	} &> /dev/null
	# Running "pc" benchmark on 8 MiB of memoy
	taskset -c 6 ./pc $(( 8 * 2**20 )) 500 > pc_DRAM_1.dat
	# Running "pc" benchmark on 16 MiB of memoy
	taskset -c 7 ./pc $(( 16 * 2**20 )) 500 > pc_DRAM_2.dat
	# TODO: Drawing the pc benchmark plot

	cd ..
}

function reduc_benchmark() {
	# ==================================
	# ======== reduc benchmark =========
	# ==================================
	# Building the "reduc" benchmark binary
	cd reduc/
	{
		make clean
		make
	} &> /dev/null
	# Running "reduc" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./reduc_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > reduc_L1.dat
	# Running "reduc" benchmark on 512 KiB of memoy (fits in L2 cache)
	taskset -c 5 ./reduc_SSE_AVX $(( 512 * 2**10 )) 1000 | cut -d';' -f1,8,9 > reduc_L2.dat
	# Running "reduc" benchmark on 2 MiB of memoy (fits in L3 cache)
	taskset -c 6 ./reduc_SSE_AVX $(( 2 * 2**20 )) 1000 | cut -d';' -f1,8,9 > reduc_L3.dat
	# Running "reduc" benchmark on 8 MiB of memoy (fits in DRAM)
	taskset -c 7 ./reduc_SSE_AVX $(( 8 * 2**20 )) 1000 | cut -d';' -f1,8,9 > reduc_DRAM.dat
	# Drawing the reduc benchmark plot
	cd ..
	gnuplot -c "plot_reduc_bw.gp" > reduc_bw.png
}

function dp_benchmark() {
	# ==================================
	# ======= dotprod benchmark ========
	# ==================================
	# Building the "dotprod" benchmark binary
	cd dotprod/
	{
		make clean
		make
	} &> /dev/null
	# Running "dotprod" benchmark on 64 KiB of memoy (fits in L1 cache)
	taskset -c 4 ./dotprod_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > dotprod_L1.dat
	# Running "dotprod" benchmark on 512 KiB of memoy (fits in L2 cache)
	taskset -c 5 ./dotprod_SSE_AVX $(( 512 * 2**10 )) 1000 | cut -d';' -f1,8,9 > dotprod_L2.dat
	# Running "dotprod" benchmark on 2 MiB of memoy (fits in L3 cache)
	taskset -c 6 ./dotprod_SSE_AVX $(( 2 * 2**20 )) 750 | cut -d';' -f1,8,9 > dotprod_L3.dat
	# Running "dotprod" benchmark on 8 MiB of memoy (fits in DRAM)
	taskset -c 7 ./dotprod_SSE_AVX $(( 8 * 2**20 )) 500 | cut -d';' -f1,8,9 > dotprod_DRAM.dat
	# Drawing the dotprod benchmark plot
	cd ..
	gnuplot -c "plot_dotprod_bw.gp" > dotprod_bw.png
}

function triad_benchmark() {
	# ==================================
	# ======== triad benchmark =========
	# ==================================
	# Building the "triad" benchmark binary
	cd triad/
	{
		make clean
		make
	} &> /dev/null
	# Running "triad" benchmark on 64 KiB of memory (fits in L1 cache)
	taskset -c 4 ./triad_SSE_AVX $(( 64 * 2**10 )) 1000 | cut -d';' -f1,8,9 > triad_L1.dat
	# Running "triad" benchmark on 512 KiB of memory (fits in L2 cache)
	taskset -c 5 ./triad_SSE_AVX $(( 512 * 2**10 )) 1000 | cut -d';' -f1,8,9 > triad_L2.dat
	# Running "triad" benchmark on 2 MiB of memory (fits in L3 cache)
	taskset -c 6 ./triad_SSE_AVX $(( 2 * 2**20 )) 500 | cut -d';' -f1,8,9 > triad_L3.dat
	# Running "triad" benchmark on 8 MiB of memory (fits in DRAM)
	taskset -c 7 ./triad_SSE_AVX $(( 8 * 2**20 )) 100 | cut -d';' -f1,8,9 > triad_DRAM.dat
	
	# Drawing the triad benchmark plot
	cd ..
	gnuplot -c "plot_triad_bw.gp" > triad_bw.png
}

# Main
if [ $# -gt 0 ]; then
	for bench in $@; do
		case $bench in
			"load")
				echo "Running 'load' benchmark.."
				load_benchmark;;
			"store")
				echo "Running 'store' benchmark.."
				store_benchmark;;
			"ntstore")
				echo "Running 'ntstore' benchmark.."
				ntstore_benchmark;;
			"copy")
				echo "Running 'copy' benchmark.."
				copy_benchmark;;
			"memcpy")
				echo "Running 'memcpy' benchmark.."
				memcpy_benchmark;;
			"pc")
				echo "Running 'pc' benchmark.."
				pc_benchmark;;
			"reduc")
				echo "Running 'reduc' benchmark.."
				reduc_benchmark;;
			"dotprod")
				echo "Running 'dotprod' benchmark.."
				dp_benchmark;;
			"triad")
				echo "Running 'triad' benchmark.."
				triad_benchmark;;
			"all")
				echo "Running 'load' benchmark.."
				load_benchmark
				echo "Running 'store' benchmark.."
				store_benchmark
				echo "Running 'ntstore' benchmark.."
				ntstore_benchmark
				echo "Running 'copy' benchmark.."
				copy_benchmark
				echo "Running 'memcpy' benchmark.."
				memcpy_benchmark
				echo "Running 'pc' benchmark.."
				pc_benchmark
				echo "Running 'reduc' benchmark.."
				reduc_benchmark
				echo "Running 'dotprod' benchmark.."
				dp_benchmark
				echo "Running 'triad' benchmark.."
				triad_benchmark	;;
			*)
				echo "wrong benchmark name!";;
		esac
	done
else
	echo "usage: sudo sh bash.sh [all | bechmark_names..]"
fi

# Restarting NetworkManager
echo "Restarting NetworkManager.."
systemctl start NetworkManager --now
# Resetting CPU frequency settings
echo "Resetting cpu frequency to POWERSAVE.."
cpupower frequency-set -g powersave

