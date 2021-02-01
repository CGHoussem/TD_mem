set term png size 1900,1000 enhanced font "Terminal,10"

set grid

set auto x

set key left top

set title "Intel(R) Core(TM) i5-8250U CPU @ 1.60 GHz bandwidth (in GiB/s) for a 'load' benchmark on a single array"

set xlabel "Benchmark variants"
set ylabel "Bandwidth in GiB/s (higher is better)

set style data histogram
set style fill solid border -1
set boxwidth 0.9

set multiplot layout 2,1 rowsfirst

set xtic rotate by -45 scale 0

set datafile separator ";"

set yrange [0:150]

plot 	"load/load_L1.dat" u 3:xtic(1) t "Intel Core i5-8250U (L1 - 64 KiB)", \
	"load/load_L2.dat" u 3:xtic(1) t "Intel Core i5-8250U (L2 - 512 KiB)", \
	"load/load_L3.dat" u 3:xtic(1) t "Intel Core i5-8250U (L3 - 2 MiB)", \
	"load/load_DRAM.dat" u 3:xtic(1) t "Intel Core i5-8250U (DRAM - 8 MiB)"

set title "Intel(R) Core(TM) i5-8250U CPU @ 1.60 GHz deviation percentage for a 'load' benchmark on a single array"

set yrange [0:8]

plot 	"load/load_L1.dat" u 2:xtic(1) t "Intel Core i5-8250U (L1 - 64 KiB)", \
	"load/load_L2.dat" u 2:xtic(1) t "Intel Core i5-8250U (L2 - 512 KiB)", \
	"load/load_L3.dat" u 2:xtic(1) t "Intel Core i5-8250U (L3 - 2 MiB)", \
	"load/load_DRAM.dat" u 2:xtic(1) t "Intel Core i5-8250U (DRAM - 8 MiB)"

unset multiplot
