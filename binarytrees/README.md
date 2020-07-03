# Binary Trees Benchmark

Focused on single threaded performance, so benchmarking to the
idiomatic python and lua single-threaded solutions.  No tweaks,
Janet is the winner.

```
$ janet binarytrees1.janet 21
$ python binarytrees2.python 21
$ lua binarytrees2.lua 21
```

* binarytrees1.janet: **75s**
* binarytrees2.py: **109s**
* binarytrees2.lua: **218s**

