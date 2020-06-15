(import ./build/arraymod as arraymod)

(def a @[1 2 3 4 5])
(arraymod/flip a 3)
(pp a)
(assert (deep= a @[4 3 2 1 5]))

(def a @[1 2])
(arraymod/flip a 1)
(assert (deep= a @[2 1]) "flip 1")
(def a @[1 2 3])
(arraymod/flip a 2)
(assert (deep= a @[3 2 1]) "flip 2")
(def a @[1 2 3 4 5])
(arraymod/flip a 3)
(assert (deep= a @[4 3 2 1 5]) "flip 3")

