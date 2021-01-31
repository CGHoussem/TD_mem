set term png size 1900,1000 enhanced font "Terminal,10"

set grid

set auto x

set key left top

set title "Intel(R) Core(TM) i5-8250U CPU @ 1.60 GHz bandwidth (in GiB/s) for a triad operation on three arrays"

set xlabel "Benchmark variants"
set ylabel "Bandwidth in GiB/s (higher is better)

set style data histogram
set style fill solid border -1
set boxwidth 0.9

set xtic rotate by -45 scale 0

set multiplot layout 2, 2 rowsfirst

set yrange [0:100]

set title "L1 cache"
plot "triad/triad_L1.dat" u 2:xtic(1) t "Intel Core i5-8250U"

set title "L2 cache"
plot "triad/triad_L2.dat" u 2:xtic(1) t "Intel Core i5-8250U"

set title "L3 cache"
plot "triad/triad_L3.dat" u 2:xtic(1) t "Intel Core i5-8250U"

set title "DRAM"
plot "triad/triad_DRAM.dat" u 2:xtic(1) t "Intel Core i5-8250U"

unset multiplot
