
(defn bench [f &opt msg]
  (default msg "BENCH")
  (def start (os/clock))
  (def ans (f))
  (def end (os/clock))
  (printf "%s: %f" msg (- end start))
  ans)

