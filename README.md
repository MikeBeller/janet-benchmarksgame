# janet-benchmarksgame

Versions of the [Computer Language Benchmarks Game](https://benchmarksgame-team.pages.debian.net/benchmarksgame/index.html)
benchmarks for the [Janet language](https://janet-lang.org/).

Goal is to explore Janet language performance.

TL;DR [summary graph is here:](summary.ipynb)

## Explanation

Representative versions from other languages (typically Python and Lua),
taken from the benchmarksgame site, are included in the various benchmark
directories in order to give reference points for performance.  

The comparables from the benchmarks game site not chosen by taking
the absolute fastest from that site, as often the absolute fastest
is based on multithreaded performance (whereas I am focused on single-threaded
performance in this project), or because the absolute fastest is hyper-
optimized and non-idiomatic (unreadable) and I wanted to focus on the
benchmarking of reasonably idiomatic and readable code.

I've done all my timings on a `Intel(R) Core(TM) i5-7500 CPU @ 3.40GHz`, 4
cores, with hyperthreading disabled.  However as mentioned above, often my
implementations of the benchmarks are focused on single-thread performance.

Note -- per suggestion from @bakpakin, **all timings are given for a Janet
binary compiled with LTO**.  This reduces run time by as much as 30% in some
cases over a Janet compiled without LTO.  To compile with LTO just add
`export CFLAGS='-fPIC -O2 -flto'` before your compile.

## Running the benchmarks yourself

Make sure you have a LTO-compiled Janet installed if you want best
performance. (see above).

You also need a lua and a python in your path installed as "lua" and "python".

```
jpm deps 
janet runbench.janet >bench.log  # this takes like 15 minutes! tail -f to monitor
```

To recreate the graphs you need jupyter notebook installed, with
numpy, pandas, matplotlib.  Just rerun all the sells in summary.ipynb.

## Ideas for Improving Janet Performance

Based on the benchmarks I've implemented so far, here are some ideas for
Janet that would improve the performance on these benchmarks.

* An equivalent of buffer/blit for arrays (e.g. array/blit) would help
  as a lot of benchmarks involve moving things between arrays, and if
  you use Janet's indexed combinators, they are always allocating new
  arrays. (See fannkuch)  array/reverse-in would also be great.
* Some way to profile Janet code to see where it spends its time.
  (@andrewchambers suggests a sampling profiler could be built by
  periodically sampling a fiber's vm stack.)

