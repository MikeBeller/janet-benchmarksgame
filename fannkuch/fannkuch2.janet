
(defn factorial [n]
  (assert (< n 19))  # overflow for Janet
  (assert (>= n 0))
  (if (< n 2) 1
    (product (range 2 (inc n)))))

(defn rotate-slice
  "Rotate left elements of array a from index i through
   (and including) index j.  Assumes i,j are valid indexes."
  [a i j]
  (def ai (a i))
  (for k i j
    (put a k (a (inc k))))
  (put a j ai))

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

(defn fannkuch [n]
  (var checksum 0)
  (var sign 1)
  (var maxflips 0)
  (def cnt (array/new-filled n 0))
  (def perm (range n))

  (def idxmax (factorial n))
  (var idx 0)
  (def p (array/new-filled n 0))
  (while true
    # Count flips for this permutation
    (var nflips 0)
    #(def p (array/slice perm))
    (array/remove p 0 n)
    (array/insert p 0 ;perm)
    (while (not= (p 0) 0)
      (reverse-slice p 0 (p 0))
      (++ nflips))
    (+= checksum (* sign nflips))
    (set sign (- sign))
    (if (> nflips maxflips)
      (set maxflips nflips))
    (when (= (++ idx) idxmax) (break))

    # Generate next permutation
    (rotate-slice perm 0 1)
    (var i 1)
    (while true
      (++ (cnt i))
      (when (<= (cnt i) i) (break))
      (put cnt i 0)
      (++ i)
      (rotate-slice perm 0 i)))

  [checksum maxflips])

#(assert (= [228 16] (fannkuch 7)))
(def arg (scan-number ((dyn :args) 1)))
(def [checksum mf] (fannkuch arg))
(print checksum)
(printf "Pfannkuchen(%d) = %d" arg mf)

