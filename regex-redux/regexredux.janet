
(defn read-seq [fname]
  (with [infile (file/open fname)]
    (loop [line :iterate (file/read infile :line)
           :until (string/has-prefix? ">THREE " line)])
    (string/ascii-upper
      (string/join
        (seq [line :iterate (file/read infile :line)
              :until (= (line 0) (chr ">"))]
          (string/trimr line))))))

(gcsetinterval 1000000000)
(def fpath (get (dyn :args) 1))
(def data (read-seq fpath))

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

# comparable PEGs -- we do a very limited automatic conversion to PEG from RE
(defn conv-pat
  ``convert, for example: 'ag[act]ggg' to (* "ag" (set "act") "ggg")``
  [pat]
  (match
    (peg/match
      ~{:l (set "acgt")
        :main (* (<- (any :l)) "[" (<- (some :l)) "]" (<- (any :l)))}
      pat)
    @[a b c] ~(* ,a (set ,b) ,c)
    pat))

(assert (deep= '(* "agg" (set "act") "taaa") (conv-pat "agg[act]taaa")))

(defn re-to-peg
  "Convert regexes to pegs that match (a very restricted set of) regexes,
  and return the locations of the found matches."
  [pat]
  (def [a b] (string/split "|" pat))
  (def sub-pg ~(+ ,(conv-pat a) ,(conv-pat b)))
  ~(any (+ (* ($) ,sub-pg) 1)))


(def pegs
  (seq [pat :in patterns]
    (def pg (re-to-peg pat))
    (pp pg)
    (peg/compile pg)))

(pp (peg/match (in pegs 0) "gagaagggtaagagattacctat"))

(defn regexredux [data]
  (loop [i :range [0 (length patterns)]]
    (def r (peg/match (in pegs i) data))
    (pp r)
    (printf "%s %d" (in patterns i) (length r))))

(regexredux data)

