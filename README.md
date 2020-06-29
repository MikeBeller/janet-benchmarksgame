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

Note -- per suggestion from @bakpakin, **all timings are given for a Janet
binary compiled with LTO**.  This reduces run time by as much as 30% in some
cases over a Janet compiled without LTO.  To compile with LTO just add
`export CFLAGS='-fPIC -O2 -flto'` before your compile.

## Ideas for Janet Performance

Based on the benchmarks I've implemented so far, here are some ideas for
Janet that would improve the performance on these benchmarks.

* Improvements to the Garbage Collector?  In particular with default
  gcsetinterval (normally 64k in the source) some benchmarks which
  accumulate large tables essentially never complete. (Thousands of
  times slower than with gcsetinterval set large.)  Perhaps have
  gc interval auto adjust?  (See knucleotide benchmark)
* An equivalent of buffer/blit for arrays (e.g. array/blit) would help
  as a lot of benchmarks involve moving things between arrays, and if
  you use Janet's indexed combinators, they are always allocating new
  arrays. (See fannkuch)  array/reverse-in would also be great.
* Some way to profile Janet code to see where it spends its time.
  (@andrewchambers suggests a sampling profiler could be built by
  periodically sampling a fiber's vm stack.)

