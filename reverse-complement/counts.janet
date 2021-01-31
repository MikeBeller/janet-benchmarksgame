
(defn main [& args]
  #(def freqs @{})
  (def freqs (array/new-filled 128))
  (with [f (file/open (in args 1))]
    (loop [line :iterate (file/read f :line)
           :when (not= (in line 0) (chr ">"))]
      (loop [c :in (string/ascii-upper line)]
        #(put freqs c (inc (get freqs c 0))))))
        (def n (in freqs c))
        (set (freqs c) (if n (+ 1 n) 1)))))
  (loop [[k v] :pairs freqs
         :when (and v (not= 10 k))]
    (printf "%c %d" k v)))

