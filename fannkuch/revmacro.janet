# Develop an optimized function table for array reversal 

(defmacro gen-rev [i]
       ~(fn [a] ,i))

(def rev-tab (seq [i :range [0 20]] (gen-rev i)))

(print ((in rev-tab 3) 7))

(defn gen-rev-help [n]
  (def r @[])
  (for i 0 (/ n 2)
    (array/push r (tuple 'set 't (tuple 'in 'a i)))
    (array/push r (tuple 'put 'a i (tuple 'in 'a (- n i))))
    (array/push r (tuple 'put 'a (- n i) 't)))
  r)

#(pp (gen-rev-help 5))

(defmacro gen-rev [n]
       ~(fn [a]
          (var t 0)
          ,;(gen-rev-help n)))

(pp (macex1 '(gen-rev 5)))

(def rev-tab (seq [i :range [0 18]] (eval ~(gen-rev ,i))))


(def aa (range 10))
(pp aa)
((rev-tab 7) aa)
(pp aa)
(assert (deep= aa @[7 6 5 4 3 2 1 0 8 9]))


