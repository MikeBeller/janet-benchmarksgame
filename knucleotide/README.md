# K-Nucleotide Benchmark

Initially a single threaded version, for 25,000,000 size.

To generate the input data, run

python fasta2.py 25000000 >input25000000.txt

NOTE: For Janet you must `(gcsetinterval 100000000)` at least,
or something larger in order to get even semi-decent performance.  These
results (for the 25,000,000 file) were with (gcsetinterval 1000000000)
i.e. 1GB (!):

## Janet -- with gcsetinterval 1000000000

Janet: **168 seconds** (226 seconds non LTO -- LTO gave 25% improvement)
Python3: 160 seconds
Lua: 80s

## Janet -- without gcsetinterval:

**greater than 1280 minutes** (never finished)
Points to some need to auto-adjust gc interval??


