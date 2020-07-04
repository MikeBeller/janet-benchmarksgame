# Take fannkuch4 and add threads
#  Takes an extra argument of number of threads to run

(defn factorial [n]
  (assert (< n 19))  # overflow for Janet
  (assert (>= n 0))
  (if (< n 2) 1
    (product (range 2 (inc n)))))

(defn rotate-slice
  "Rotate left elements of array a from index i through
  (and including) index j.  Assumes i,j are valid indexes."
  [a i j]
  (def ai (in a i))
  (array/remove a i)
  (array/insert a j ai))

(defn gen-rev-help [n]
  (def r @[])
  (for i 0 (/ n 2)
    (array/push r (tuple 'set 't (tuple 'in 'a i)))
    (array/push r (tuple 'put 'a i (tuple 'in 'a (- n i))))
    (array/push r (tuple 'put 'a (- n i) 't)))
  r)

(defmacro gen-rev [n]
       ~(fn [a]
          (var t 0)
          ,;(gen-rev-help n)))

(def rev-tab (seq [i :range [0 18]] (eval ~(gen-rev ,i))))

(let [a @[1 2]] ((in rev-tab 1) a) (assert (deep= a @[2 1])))
(let [a @[1 2 3]] ((in rev-tab 2) a) (assert (deep= a @[3 2 1])))
(let [a @[1 2 3 4 5]] ((in rev-tab 3) a) (assert (deep= a @[4 3 2 1 5])))

(defn array-blit [dst src dstart sstart send]
  (for i 0 (- send sstart)
    (put dst (+ dstart i) (src (+ sstart i))))
  dst)

(defn fannkuch-task [n idxstart size rev-tab]
  (def idxmax (+ idxstart size))
  (var checksum 0)
  (var sign 1)
  (var maxflips 0)

  (def perm (range n))
  (def cnt (array/new-filled n 0))
  (var idx idxstart)
  (def perm1 (array/new-filled n 0))
  (loop [i :down [(dec n) 0]
         :let [fi (factorial i)]]
    (def d (math/floor (/ idx fi)))
    (put cnt i d)
    (set idx (% idx fi))
    (array-blit perm1 perm 0 0 (inc i))
    (for j 0 (inc i)
      (put perm j (if (<= (+ d j) i)
                 (perm1 (+ d j))
                 (perm1 (+ d j (- i) -1))))))

  (var idx idxstart)
  (def p (array/new-filled n 0))
  (while true
    # Count flips for this permutation
    (var nflips 0)
    #(def p (array/slice perm))
    (array/remove p 0 n)
    (array/insert p 0 ;perm)
    (while (not= (p 0) 0)
      ((rev-tab (in p 0)) p)
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

(defn fannkuch-mt [n ntasks]
  (def factn (factorial n))
  (def tasksize (math/floor (/ (+ factn ntasks -1) ntasks)))
  (assert (= 0 (% tasksize 2)) "must be even for checksums to sum correctly")
  (for ti 0 ntasks
      (def th
           (thread/new (fn [parent] 
                  (def rev-tab (thread/receive math/inf))
                  (def res (fannkuch-task n (* tasksize ti) tasksize rev-tab))
                  (thread/send parent res))))
      (thread/send th rev-tab))
  (def res
    (seq [ti :range [0 ntasks]]
      (thread/receive math/inf)))
  [(sum (map |(in $ 0) res)) (max ;(map |($ 1) res))])

(assert (= [228 16] (fannkuch-mt 7 2)))
(assert (= [228 16] (fannkuch-mt 7 4)))

(def arg (scan-number ((dyn :args) 1)))
(def NCORES (if (> (length (dyn :args)) 2)
              (scan-number ((dyn :args) 2))
              4))
(def [checksum mf] (fannkuch-mt arg NCORES))
(print checksum)
(printf "Pfannkuchen(%d) = %d" arg mf)

