
(defn read-seq [fname]
  (with [infile (file/open fname)]
    (loop [line :iterate (file/read infile :line)
           :until (string/has-prefix? ">THREE " line)])
    (string/ascii-upper
      (string/join
        (seq [line :iterate (file/read infile :line)
              :until (= (line 0) (chr ">"))]
          (string/trimr line))))))

(def data (read-seq "knucleotide-input.txt"))

(defn print-by-freq [tb]
  (def n (sum (values tb)))
  (def ps (pairs tb))
  (sort-by |(- ($ 1)) ps)
  (each [k v] ps
    (printf "%c: %.03f" k (* 100 (/ v n)))))

(defn knucleotide [data]
  (def f1 (frequencies data))
  (print-by-freq f1))

(knucleotide data)

