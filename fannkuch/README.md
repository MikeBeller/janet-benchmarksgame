# Fannkuch-redux benchmark

## Naive, single-threaded version

For n = 10

* fannkuch1.janet: **12.5s** Using a generator for the permutations
* fannkuch2.janet: **8.9s** Inlining the permutations into the main code

Compare to fannkuch.py: 4.8s, fannkuch.lua: 2.8s

## Multithreaded version

* fannkuch3.janet: **2.4s** real or **9.4s** user on a 4-core system

Compare to fannkuch_par.py: **1.5s** real or **5.4s** user

