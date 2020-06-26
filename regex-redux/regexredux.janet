
(gcsetinterval 1000000000)

# patterns from the benchmark -- we will convert to pegs
(def match-regexes [
               "agggtaaa|tttaccct"
               "[cgt]gggtaaa|tttaccc[acg]"
               "a[act]ggtaaa|tttacc[agt]t"
               "ag[act]gtaaa|tttac[agt]ct"
               "agg[act]taaa|ttta[agt]cct"
               "aggg[acg]aaa|ttt[cgt]ccct"
               "agggt[cgt]aa|tt[acg]accct"
               "agggta[cgt]a|t[acg]taccct"
               "agggtaa[cgt]|[acg]ttaccct"])

(def subst-regex-pairs [
            [ "tHa[Nt]" "<4>" ]
            [ "aND|caN|Ha[DS]|WaS" "<3>" ]
            [ "a[NSt]|BY" "<2>" ]
            #[ "<[^>]*>" "|" ]  -- too lazy to expand re converter
            #[ "\\|[^|][^|]*\\|" "-" ]
            [ '(* "<" (thru ">")) "|"]
            [ '(* "|" (if-not "|" 1) (thru "|")) "-"]
            ])

(defn real-re-to-peg [re-str]
  (def m
    (peg/match
      ~{:p (drop (cmt ($) ,(fn [n] (print "AT: " n) n)))
        #:l (set "acgt")
        :l :a
        :letters (<- (some :l))
        :wild (* "[" (cmt :letters ,(fn [ls] (tuple 'set ls))) "]")
        :sub (+ :letters :wild)
        :word (cmt (some :sub) ,(fn [& ss] (tuple '* ;ss)))
        :words (cmt (* :word "|" :word) ,(fn [& wds] (tuple '+ ;wds)))
        :main (+ :words :word)
        }
      re-str))
  (match m
    @[pg] pg
    (errorf "unsupported regex pattern: %s" re-str)))

(defn re-to-peg [re-str-or-tuple]
  (if (tuple? re-str-or-tuple) re-str-or-tuple
    (real-re-to-peg re-str-or-tuple)))

(defn finder
  "Creates a peg that finds all locations of pg (a PEG) in the text."
  [pg]
  (peg/compile ~(any (+ (* ($) ,pg) 1))))

(assert (deep= @[2 5] (peg/match (finder "x") "abxcdxe")))

(defn substituter
  "Creates a peg that replaces every instance of pg with rep"
  [pg rep]
  (peg/compile ~(% (any (+ (/ (<- ,pg) ,rep) (<- 1))))))

(assert (deep= @["aabarxbarnotbar"]
               (peg/match (substituter "foo" "bar") "aafooxfoonotfoo")))

(assert
  (deep= @[4 16]
         (peg/match (finder (re-to-peg (in match-regexes 0)))
                    "gagaagggtaaagagatttaccctat")))
(assert (deep= @[2] (peg/match (finder (re-to-peg (in match-regexes 1))) "aacgggtaaa")))

(defn regexredux []
  # Read data
  (def fpath (get (dyn :args) 1))
  (def file-contents (slurp fpath))
  (def data
    (string/join
      (seq [s :in (string/split "\n" file-contents)
            :when (not (string/has-prefix? ">" s))]
        (string/trimr s))))

  # Counting
  (loop [regex :in match-regexes]
    (def pg (finder (re-to-peg regex)))
    (def r (peg/match pg data))
    (printf "%s %d" regex (length r)))

  # Replacing
  (var d data)
  (loop [[regex sub] :in subst-regex-pairs]
    (def pg (substituter (re-to-peg regex) sub))
    (def r (peg/match pg d))
    (match r
      @[s] (set d s)
      (errorf "Unexpected lack of match: %s" regex)))

  # results
  (printf "\n%d\n%d\n%d" (length file-contents) (length data) (length d)))

(regexredux)
