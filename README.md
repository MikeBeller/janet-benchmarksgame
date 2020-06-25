# janet-benchmarksgame

Versions of the [Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html)
benchmarks for the [Janet language](https://janet-lang.org/).

Goal is to explore Janet language performance.

Representative versions from other languages (typically Python and Lua),
taken from the benchmarksgame site, are included in the various benchmark
directories in order to give reference points for performance.  Often
I am focused on single-threaded performance, so the reference benchmarks
that I put in the directories are not necessarily the fastest ones on
the benchmarksgame site, but rather ones that I think are useful
in some sense as "comparables".  

I've done all my timings on a `Intel(R) Core(TM) i5-7500 CPU @ 3.40GHz`, 4
cores, with hyperthreading disabled.  However as mentioned above, often my
implementations of the benchmarks are focused on single-thread performance.

