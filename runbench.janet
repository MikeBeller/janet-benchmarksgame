(import spork/path)

(defn time-cmd [cmd]
  (def c (tuple "/usr/bin/time" "--format" "%U %S %x" ;cmd))
  (pp c)
  (def tms
    (with [p (os/spawn c :px {:err :pipe})]
      (:read (p :err) :all)))
  (def pm
    (peg/match
      '(* (<- (* :d+ "." :d+)) " " (<- (* :d+ "." :d+)) " " (<- :d+))
      tms))
  (if (and pm (= (length pm) 3) (= (in pm 2) "0"))
    [(scan-number (in pm 0)) (scan-number (in pm 1))]
    (do
      (print "error running cmd: " tms)
      (os/exit 1))))

#(assert (= 2 (length (time-cmd ["ls" "-l"]))))

(def langs
  [{:name :janet :exec "janet"}
  {:name :python :exec "python"}
  {:name :lua :exec "lua"}])

(def all-benches [
              {:name "fannkuch"
               :dir "fannkuch"
               :arg 10
               :janet "fannkuch4-bakpakin.janet"
               :python "fannkuch.py"
               :lua "fannkuch.lua"}
              {:name "binarytrees"
               :dir "binarytrees"
               :arg 21
               :janet "binarytrees1.janet"
               :python "binarytrees2.py"
               :lua "binarytrees2.lua"}
              {:name "knucleotide"
               :dir "knucleotide"
               :arg "knucleotide/input25000000.txt"
               :janet "knucleotide2.janet"
               :python "knucleotide8.py"
               :lua "knucleotide2.lua"}
              {:name "nbody"
               :dir "nbody"
               :arg "5000000"
               :janet "nbody2.janet"
               :python "nbody.py"
               :lua "nbody2.lua"}
              {:name "pidigits"
               :dir "pidigits"
               :arg "10000"
               :janet "pidigits.janet"
               :python "pidigits4.py"
               :lua nil}
              {:name "regexredux"
               :dir "regex-redux"
               :arg "regex-redux/input5000000.txt"
               :janet "regexredux2.janet"
               :python "regexredux1.py"
               :lua nil}
              {:name "reverse-complement"
               :dir "reverse-complement"
               :arg "reverse-complement/input100000000.txt"
               :janet "revcomp2.janet"
               :python "revcomp.py"
               :lua "revcomp2.lua"}

              ])

(defn main [& args]
  (def benches
    (if (= (length args) 2)
      (filter |(string/find (in args 1) (in $ :name)) all-benches)
      all-benches))
  (print "BENCHXXX: name," (string/join (seq [l :in langs] (l :name)) ","))
  (each bench benches
    (def times
      (seq [{:name langname :exec langexec} :in langs ]
        (if-let [bfilename (in bench langname)]
          (do
            (def bfile (path/join (in bench :dir) bfilename))
            (def r (time-cmd [langexec bfile (string (in bench :arg))]))
            (sum r))
          math/nan)))
    (print "BENCHXXX: " (in bench :name) "," (string/join (map string times) ","))))

