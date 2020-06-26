# Regex Redux Benchmark

The rules say you have to use the exact regex given for your comparison,
but I think it's much more interesting to see how Janet PEGs stack up
against regexes in languages like Python and Lua.

So my approach is to create a converter from the regexes to PEGs.  (The
converter is limited to the patterns needed for this benchmark, not
a general regex to PEG converter.)

Current todos:

* Find slight error in results (one re is wrong?)
* Finish Regex to Peg converter so last two examples convert correctly

## Results for input5000000

Take results with a grain of salt as we still have a bug

regexredux.janet **31.2s**
regexredux1.py   **11.3s**

So in our implementation Janet PEGS are around 1/3 speed of Python REs.
NOTE: In the actual benchmarks site, faster implementations are ditching
Python's internal regex engine and using PCRE library.  If we wanted to do
the same we would probably get those same, faster, results.  But what would
we learn about Janet?  Not much.  So not doing that.

