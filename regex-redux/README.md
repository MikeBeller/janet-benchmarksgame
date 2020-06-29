# Regex Redux Benchmark

The rules say you have to use the exact regex given in the benchmark
description for your performance comparison, but I think it's much more
interesting to see how Janet PEGs stack up against regexes in languages like
Python and Lua.

But rather than hand-craft the PEGs corresponding to the regexes, my
approach is to create a converter from the regexes to PEGs.  The converter
is limited to handling the regex patterns needed for this benchmark, not a
general regex to PEG converter.

## Results for input5000000

regexredux.janet **29.1s**
regexredux1.py   **11.3s**

So in our implementation Janet PEGS are around 1/3 speed of Python REs.
NOTE: In the official "computer language benchmarks" site, there are faster
python (and lua) implementations which use the "PCRE" library, which
includes a JIT compiler.  Those solutions are like 6 times faster than
python REs, so PEGs are far from the speed of that library.

Of course we could wrap PCRE in Janet but that's not the point of my tests.
I'm trying to test Janet's speed on the benchmarks.

Note -- Janet compiled without LTO ran in 31.5s so LTO only improves by
around 8% for this benchmark -- whereas for others it was more like
25-30%.  This is probably because timing is just dominated by the running
time of the peg/match, which doesn't cross link-time boundaries (?)
