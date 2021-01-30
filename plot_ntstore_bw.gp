set term png size 1900,1000 enhanced font "Terminal,10"

set grid

set auto x

set key left top

set title "Intel(R) Core(TM) i5-8250U CPU @ 1.60 GHz bandwidth (in GiB/s) for a ntstore benchmark on a single array"

set xlabel "Benchmark variants"
set ylabel "Bandwidth in GiB/s (higher is better)

set style data histogram
set style fill solid border -1
set boxwidth 0.9

set xtic rotate by -45 scale 0

set multiplot layout 2, 2 rowsfirst

set yrange [0:20]

set title "DRAM 1 GiB"
plot "ntstore/ntstore_DRAM_1.dat" u 2:xtic(1) t "Intel Core i5-8250U"

set yrange [0:110]

set title "DRAM 2 GiB"
plot "ntstore/ntstore_DRAM_2.dat" u 2:xtic(1) t "Intel Core i5-8250U"

unset multiplot
