
(defn bottom-up-tree [depth]
  (if (= depth 0)
    nil
    (let [d (dec depth)]
      [(bottom-up-tree d) (bottom-up-tree d)])))

(defn item-check [t]
  (if-let [[l r] t]
    (+ 1 (item-check l) (item-check r))
    1))

(defn binarytrees [n]
  (def mindepth 4)
  (def maxdepth (max n (+ mindepth 2)))

  (let [stretchdepth (inc maxdepth)
        stretchtree (bottom-up-tree stretchdepth)]
    (printf "stretch tree of depth %d\t check: %d"
            stretchdepth (item-check stretchtree)))

  (def longlivedtree (bottom-up-tree maxdepth))

  (loop [depth :range-to [mindepth maxdepth 2]]
    (def iterations (math/pow 2 (+ maxdepth (- depth) mindepth)))
    (def check
      (sum
           (seq [:repeat iterations]
             (item-check (bottom-up-tree depth)))))
    (printf "%d\t trees of depth %d\t check: %d"
            iterations depth check))

  (printf "long lived tree of depth %d\t check: %d"
          maxdepth (item-check longlivedtree)))

(def n (scan-number (get (dyn :args) 1 "0")))
(binarytrees n)

