#!/bin/bash
clear

# Stop NetworkManager
systemctl stop NetworkManager


# Setting up CPU frequencies
cpupower frequency-set -g performance
cpupower frequency-set -f 3.4GHz

# Creating directories
if [ ! -d "system" ]; then
	mkdir system system/cpu system/caches system/memory
else
	if [ ! -d "system/cpu" ]; then
		mkdir system/cpy
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

# Populating the memory directory
cat /proc/meminfo > system/memory/info.txt

# Building the "load" benchmark binary
cd load
make clean
make

# Running "load" benchmark on 128 KiB of memoy (fits in L1 cache)
taskset -c 1 ./load_SSE_AVX $(( 128 * 2**10 )) 1000 | cut -d';' -f1,9 > load_L1.dat
# Running "load" benchmark on 4 MiB of memory (fits in L2 cache)
taskset -c 2 ./load_SSE_AVX $(( 4 * 2**20 )) 500 | cut -d';' -f1,9 > load_L2.dat
# Running "load" benchmark on 16 MiB of memory (fits in L3 cache)
taskset -c 3 ./load_SSE_AVX $(( 16 * 2**20 )) 100 | cut -d';' -f1,9 > load_L3.dat
# Running "load" benchmark on 1 GiB of memory (fits in DRAM)
taskset -c 4 ./load_SSE_AVX $(( 1 * 2**30 )) 10 | cut -d';' -f1,9 > load_DRAM.dat

# Drawing the plots
# TODO

cd ..
