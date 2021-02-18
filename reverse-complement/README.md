# [Reverse Complement](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/revcomp.html#revcomp)

A lot of byte shuffling and byte translation.

Python does well at this because it includes a built-in string.translate
which translates a set of characters to some other set of characters
according to a translation table.  (In C obviously.)

Neither Lua nor Janet have such.  Naive version revcomp.janet runs
70 seconds, vs 9 seconds for python.  By adding memoization the translated
and reversed substrings of groups of characters, you can get it down to
33 seconds, which is also by the way the same performance as the memoized
lua version.
