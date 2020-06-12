# K-Nucleotide Benchmark

Initially a single threaded version, for 25,000,000 size:

NOTE: For Janet you must (gcsetinterval 100000000) or something
large in order to get even semi-decent performance.  These
results (for the 25,000,000 file) were with (gcsetinterval 1000000000)
i.e. 1GB (!).

Janet: 226 seconds
Python3: 160 seconds

