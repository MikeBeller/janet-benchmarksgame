
(defn read-seq [fname]
  (with [infile (file/open fname)]
    (loop [line :iterate (file/read infile :line)
           :until (string/has-prefix? ">THREE " line)])
    (string/ascii-lower
      (string/join
        (seq [line :iterate (file/read infile :line)
              :until (= (line 0) (chr ">"))]
          (string/trimr line))))))

(gcsetinterval 1000000000)

# patterns from the benchmark -- we will convert to pegs
(def patterns [
               "agggtaaa|tttaccct"
               "[cgt]gggtaaa|tttaccc[acg]"
               "a[act]ggtaaa|tttacc[agt]t"
               "ag[act]gtaaa|tttac[agt]ct"
               "agg[act]taaa|ttta[agt]cct"
               "aggg[acg]aaa|ttt[cgt]ccct"
               "agggt[cgt]aa|tt[acg]accct"
               "agggta[cgt]a|t[acg]taccct"
               "agggtaa[cgt]|[acg]ttaccct"])

(defn re-to-peg [re-str]
  (peg/match
    ~{:p (drop (cmt ($) ,(fn [n] (print "AT: " n) n)))
      :l (set "acgt")
      :letters (<- (some :l))
      :wild (* "[" (cmt :letters ,(fn [ls] (tuple 'set ls))) "]")
      :sub (+ :letters :wild)
      :word (cmt (some :sub) ,(fn [& ss] (tuple '* ;ss)))
      :main (cmt (* :word "|" :word) ,(fn [a b] (tuple '+ a b)))
      }
    re-str))

(defn finder
   "Creates a peg that finds all locations of pg in the text."
    [pg]
     (peg/compile ~(any (+ (* ($) ,pg) 1))))

(assert (deep= @[2 5] (peg/match (finder "x") "abxcdxe")))
(assert (deep= @[0] (peg/match '(* ($) (+ (* "agg" (set "act") "taaa") (* "ttta" (set "agt") "cct"))) "aggctaaa")))

(def pegs
  (seq [pat :in patterns]
    (match (re-to-peg pat)
      @[pg] (do (pp pg) (finder pg))
      (errorf "invalid pattern: %s" pat))))

(assert (deep= @[4 16] (peg/match (in pegs 0) "gagaagggtaaagagatttaccctat")))
(assert (deep= @[2] (peg/match (in pegs 1) "aacgggtaaa")))

(defn regexredux []
  (def fpath (get (dyn :args) 1))
  (def data (read-seq fpath))
  (print data)
  (loop [i :range [0 (length patterns)]]
    (def r (peg/match (in pegs i) data))
    #(pp r)
    (printf "%s %d" (in patterns i) (length r))))

(regexredux)

