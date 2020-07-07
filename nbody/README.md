# NBODY Benchmark

Test with argument 5000000 (note that's 5M, not 50M as is typically
used in nbody, because the algorithm is linear and I'm impatient.)

## Benchmark

nbody.lua: **15s**

## Initial implementation

Uses tables for the "bodies"

nbody.janet **42.6s**

## Improve by using arrays instead

The idea is that indexing an array by an integer is faster than indexing
a table by a keyword.  (Hash table lookup vs array lookup.)

nbody2.janet **18.2s** competitive with lua.



