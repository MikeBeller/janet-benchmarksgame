# [Fannkuch-redux benchmark](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/fannkuchredux.html#fannkuchredux)

## Naive, single-threaded version

For n = 10

* fannkuch1.janet: **8.6s** Using a generator for the permutations
* fannkuch2.janet: **6.8s** Inlining the permutations into the main code

Note: Before compiling Janet with LTO, fannkuch1 was 12.3 seconds so LTO
decreased runtime by 30% (!)

Compare to fannkuch.py: 4.8s, fannkuch.lua: 2.8s

## Optimize array lookup with :in

Note that most of the time is spent on flipping, so do some testing
to figure out how to speed it up.  See fliptest.janet

Figured out that (in a n) is way faster than (a n), and you
can see it by doing (disasm (fn [a] (in a 2))) vs the same
for (a 2) -- the former is a single op and the latter calls
"a" with arg 2.

* fannkuch2-in.janet **6.2s**

## Now unroll the flipping loop using a macro

Also determined that if you can unroll the loops you can double
the speed of the flipping, so tried unrolling the loops and putting
the result in a function table:

* fannkuch4.janet **5.2s**

## And add in an implementation of rotate-slice by @bakpakin

* fannkuch4-bakpakin.janet **4.9s**

## Now take it "up to 11" by creating a C function for flipping

Now to really speed it up we can add a C function.  Created the
arraymod module for in-place array modification, and new benchmark:

* fannkuch5.janet **3.0s**

Note this version may be "cheating" per the CLBG rules because I
wrote a C function specifically for this benchmark.  And in a sense
therefore it's not testing Janet performance.  I left this benchmark
in to give an indication of how much an addition to the Janet API
could improve things.

## Aside -- Multithreaded version

* fannkuch3.janet: **1.8s** real or **6.9s** user on a 4-core system

Compare to fannkuch_par.py: **1.5s** real or **5.4s** user
Note that this was based on a non-optimized single threaded version.
If I combine fannkuch5 (the fastest single threaded version) with
threads it should achieve < 1 second.  This version just shows how
easy it is to multithread one of these benchmarks and that you get
almost a pure 4/1 speedup on a 4-core machine.

New version based on fannkuch4 (with rev table and all optimizations):

fannkuch4-parallel.janet: **1.4s** real or **5.4s user**

Equivalent to python.
