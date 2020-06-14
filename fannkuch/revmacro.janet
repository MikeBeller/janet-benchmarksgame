# Develop an optimized function table for array reversal 

(defmacro gen-rev [i]
       ~(fn [a] ,i))

(def rev-tab (seq [i :range [0 20]] (gen-rev i)))

(print ((in rev-tab 3) 7))

