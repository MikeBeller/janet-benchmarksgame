# Fannkuch-redux benchmark

## Naive, single-threaded version

For n = 10

* fannkuch1.janet: **12.5s** Using a generator for the permutations
* fannkuch2.janet: **8.9s** Inlining the permutations into the main code

Compare to fannkuch.py: 4.8s, fannkuch.lua: 2.8s

Note that most of the time is spent on flipping, so do some testing
to figure out how to speed it up.  See fliptest.janet

Figured out that (in a n) is way faster than (a n), and you
can see it by doing (disasm (fn [a] (in a 2))) vs the same
for (a 2) -- the former is a single op and the latter calls
"a" with arg 2.

* fannkuch2-in.janet **7.98s**

Also determined that if you can unroll the loops you can double
the speed of the flipping, so tried unrolling the loops and putting
the result in a function table:

* fannkuch4.janet **6.4s**

## Multithreaded version

* fannkuch3.janet: **2.4s** real or **9.4s** user on a 4-core system

Compare to fannkuch_par.py: **1.5s** real or **5.4s** user

