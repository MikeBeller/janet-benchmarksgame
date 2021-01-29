
(defn read-seq [fname]
  (with [infile (file/open fname)]
    (loop [line :iterate (file/read infile :line)
           :until (string/has-prefix? ">THREE " line)])
    (string/ascii-upper
      (string/join
        (seq [line :iterate (file/read infile :line)
              :until (= (line 0) (chr ">"))]
          (string/trimr line))))))

#(gcsetinterval 1000000000)
(def fpath (get (dyn :args) 1))
(def data (read-seq fpath))
(def knseqs ["GGT" "GGTA" "GGTATT" "GGTATTTTAATT" "GGTATTTTAATTTATAGT"])

(defn stringify [sc]
  (case (type sc)
    :number (string/format "%c" sc)
    :string sc))

(defn print-by-freq [tb]
  (def n (sum (values tb)))
  (def ps (pairs tb))
  (sort-by |(- ($ 1)) ps)
  (each [k v] ps
    (printf "%s: %.03f" (stringify k) (* 100 (/ v n)))))

(defn counts [data len]
  (def cs @{})
  (def ns (- (+ (length data) 1) len))
  (for i 0 ns
    (def k (string/slice data i (+ i len)))
    (put cs k (+ (get cs k 0) 1)))
  cs)

(defn knucleotide [data]
  (print-by-freq (frequencies data))
  (print)
  (print-by-freq
    (frequencies
      (seq [i :range [0 (dec (length data))]]
        (string/slice data i (+ i 2)))))
  (print)
  (loop [sq :in knseqs]
    (def cs (counts data (length sq)))
    (printf "%7d %s" (get cs sq 0) sq)))

(knucleotide data)

