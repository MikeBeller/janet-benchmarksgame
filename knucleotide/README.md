# [K-Nucleotide Benchmark](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/knucleotide.html#knucleotide)

Initially a single threaded version, for 25,000,000 size.

To generate the input data, run

python fasta2.py 25000000 >input25000000.txt

NOTE: For Janet 1.9 you must `(gcsetinterval 100000000)` at least,
or something larger in order to get even semi-decent performance.  These
results (for the 25,000,000 file) were with (gcsetinterval 1000000000)
i.e. 1GB (!).  **NOT ANYMORE** since June 29, commit 7fb8c4a, Janet has
auto-gcsetinterval.  

## Janet

```
$ time janet knucleotide.janet input25000000.txt
```

Janet: **168 seconds** (226 seconds non LTO -- LTO gave 25% improvement)

Python3: 160 seconds

Lua: **80s**

### Use Keywords (Or Symbols) instead of Strings

As suggested by @bakpakin -- use keyword/slice or symbol/slice
instead of string/slice.  This will intern the strings.

```
$ time janet knucleotide.janet input25000000.txt
```

Janet: **143 seconds**

This is a 15% improvement over using strings, and actually faster
than the Python implementation.

## Janet -- without gcsetinterval:

Originally, when I ran without gcsetinterval
**greater than 1280 minutes** (never finished)
Points to some need to auto-adjust gc interval??
As of [this commit](https://github.com/janet-lang/janet/commit/95c633914f0381c9800fedbcc0c47bf70d53f62a)
on 6/27/20 auto-adjust of gc interval is now in the master branch.

