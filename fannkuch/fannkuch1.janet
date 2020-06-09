(import ../util/util :as util)

(defn factorial [n]
  (assert (< n 19))  # overflow
  (assert (>= n 0))
  (if (< n 2) 1
    (product (range 2 (inc n)))))

(defn rotate
  "Rotate left elements of array a from index i through
   (and including) index j.  Assumes i,j are valid indexes."
  [a i j]
  (def ai (a i))
  (for k i j
    (put a k (a (inc k))))
  (put a j ai))

(defn permutations
  "Returns a generator yielding all permutations of items
   in a predictable order (per the fannkuch-redux description."
  [items]
  (fiber/new
    (fn []
      (def n (length items))
      (def nfac (factorial n))
      (def c (array/new-filled n 0))
      (def perm (array/slice items))
      (yield (array/slice perm))
      (for idx 1 nfac
        (rotate perm 0 1)
        (var i 1)
        (while true
          (++ (c i))
          (when (<= (c i) i) (break))
          (put c i 0)
          (++ i)
          (rotate perm 0 i))
        (yield (array/slice perm))))))

(assert (deep=
  (seq [p :generate (permutations [:a :b :c])] (tuple/slice p))
  @[[:a :b :c] [:b :a :c] [:b :c :a] [:c :b :a] [:c :a :b] [:a :c :b]]))
(assert (= 120 (length (seq [p :generate (permutations (range 5))] 1))))

(defn swap
  "Swap items i and j in array a"
  [a i j]
  (def ai (a i))
  (put a i (a j))
  (put a j ai))

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
(def [checksum mf] (fannkuch arg))
(print checksum)
(printf "Pfannkuchen(%d) = %d" arg mf)

