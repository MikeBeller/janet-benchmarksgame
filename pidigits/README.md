# [Pi Digits](https://benchmarksgame-team.pages.debian.net/benchmarksgame/description/pidigits.html#pidigits)

## Note on Performance of Fabrice Bellard's libbf on this benchmark

Janet-big is a wrapper on [Fabrice Bellard's
libbf](https://bellard.org/libbf/).  Performance of libbf for the case where
the denominator is close in size to the numerator seems to be unusually slow.
The pidigits prescribed benchmark algorithm is perpetually dividing two numbers
which are close in size.  To address this, the Janet version of pidigits uses
successive subtraction instead of division.  This results in a 40x speedup,
making it competitive with python for example, which has built in bigints.

To be sure that this performance issue wasn't due to the janet-big package's
wrapper on libbf, I also adapted a pidigits javascript program from the
benchmarksgame main website and tested it both with node.js, and with [Fabrice
Bellard's "Quickjs"](https://bellard.org/quickjs/).  Included here is a
javascript program which demonstrates that Quickjs has the same performance
issue as Janet-big.  To see the difference you can run the program janet_qjs.js
under quickjs and comment in/out the two division vs the two successive
subtraction lines in the code.  The difference is a factor of 45 (180s vs 4
seconds). !!

