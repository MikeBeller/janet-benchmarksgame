(import ../util/util :as util)

(defn reverse-slice
  "Reverse array xs from a thru b"
  [xs a b]
  (loop [i :range [0 (/ (- b a) 2)]
         :let [ai (+ a i)
               bi (- b i)
               tmp (in xs ai)]]
         (put xs ai (xs bi))
         (put xs bi tmp)))

(let [a @[1 2]] (reverse-slice a 0 1) (assert (deep= a @[2 1])))
(let [a @[1 2 3]] (reverse-slice a 0 2) (assert (deep= a @[3 2 1])))
(let [a @[1 2 3 4 5]] (reverse-slice a 0 3) (assert (deep= a @[4 3 2 1 5])))

(defn rs7 [xs]
  (var tmp 0)
  (set tmp (xs 0)) (put xs 0 (xs 6)) (put xs 6 tmp)
  (set tmp (xs 1)) (put xs 1 (xs 5)) (put xs 5 tmp)
  (set tmp (xs 2)) (put xs 2 (xs 4)) (put xs 4 tmp))

(let [a @[1 2 3 4 5 6 7 8]] (rs7 a) (assert (deep= a @[7 6 5 4 3 2 1 8])))

(def a @[1 2 3 4 5 6 7 8])
(def n 10000000)
(defn test1 []
  (def n n)
  (def a (array/slice a))
  (loop [i :range [0 n]]
    (reverse-slice a 0 7)))

(util/bench test1 "reverse slice")

(defn test2 []
  (def n n)
  (def a (array/slice a))
  (loop [i :range [0 n]]
    (rs7 a)))

(util/bench test2 "unrolled reverse slice")

(defn test3 []
  (def n n)
  (def a (array/slice a))
  (loop [i :range [0 n]]
    ))

(util/bench test3 "empty loop")

(defn reverse-slice2
  "Reverse array xs from 0 thru b"
  [xs b]
  (var i 0)
  (var j b)
  (var tmp 0)
  (def end (math/floor (/ b 2)))
  (while (<= i end)
    (set tmp (xs i))
    (put xs i (xs j))
    (put xs j tmp)
    (++ i)
    (-- j)))

(let [a @[1 2]] (reverse-slice2 a 1) (assert (deep= a @[2 1])))
(let [a @[1 2 3]] (reverse-slice2 a 2) (assert (deep= a @[3 2 1])))
(let [a @[1 2 3 4 5]] (reverse-slice2 a 3) (assert (deep= a @[4 3 2 1 5])))

(defn test4 []
  (def n n)
  (def a (array/slice a))
  (loop [i :range [0 n]]
    (reverse-slice2 a 7)))

(util/bench test4 "slice2")

