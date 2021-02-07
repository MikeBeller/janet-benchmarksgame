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

(defn usage []
  (eprint "Usage: " (in (dyn :args) 0) " <config.jdn> <pattern>")
  (os/exit 1))

# Run benchmarks and print table of output to stderr
(defn main [& args]
  (if (< (length args) 2) (usage))
  (def [_cmd configfile pattern] args)
  (def {:langs langs :benches all-benches} (parse (slurp configfile)))
  (def benches
    (if pattern
      (filter |(string/find pattern (in $ :name)) all-benches)
      all-benches))
  (eprint "name," (string/join (seq [l :in langs] (l :name)) ","))
  (each bench benches
    (def times
      (seq [{:name langname :exec langexec} :in langs ]
        (if-let [bfilename (in bench langname)]
          (do
            (def bfile (path/join (in bench :dir) bfilename))
            (def r (time-cmd [langexec bfile (string (in bench :arg))]))
            (sum r))
          math/nan)))
    (eprint (in bench :name) "," (string/join (map string times) ","))))

