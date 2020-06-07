(import ../util/util :as util)

(defn swap [a i j]
  (def t (a i))
  (put a i (a j))
  (put a j t))

(defn permutations [items]
  (fiber/new (fn []
               (defn perm [a k]
                 (if (= k 1)
                   (yield (array/slice a))
                   (do (perm a (- k 1))
                     (for i 0 (- k 1)
                       (if (even? k)
                         (swap a i (- k 1))
                         (swap a 0 (- k 1)))
                       (perm a (- k 1))))))
               (perm (array/slice items) (length items)))))

(assert (= 120 (length (seq [p :generate (permutations (range 5))] 1))))

(defn rev
  "Reverse array xs from a thru b"
  [xs a b]
  (for i 0 (/ (- b a) 2)
    (swap xs (+ a i) (- b i))))

(let [a @[1 2]] (rev a 0 1) (assert (deep= a @[2 1])))
(let [a @[1 2 3]] (rev a 0 2) (assert (deep= a @[3 2 1])))
(let [a @[1 2 3 4 5]] (rev a 0 3) (assert (deep= a @[4 3 2 1 5])))

(defn fannkuch [n]
  (var checksum 0)
  (var sign 1)
  (var maxflips 0)
  (loop [perm :generate (permutations (range 0 n))]
    (var nflips 0)
    (while (not= (perm 0) 0)
      (rev perm 0 (perm 0))
      (++ nflips))
    (+= checksum (* sign nflips))
    (set sign (- sign))
    (if (> nflips maxflips)
      (set maxflips nflips)))
  [checksum maxflips])

(def arg (scan-number ((dyn :args) 1)))
(def [cs mf] (fannkuch arg))
(printf "fannkuch: %d %d %d" arg cs mf)


