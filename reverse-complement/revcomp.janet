
(defn maketrans [a b]
  (def r @[])
  (loop [i :range [0 (length a)]]
    (put r (in a i) (in b i)))
  r)

(def BUFSIZE (* 1024 1024))

(defn gen-sequences [infile]
  (coro
    (var linebuf (buffer/new 128))
    (var buf (buffer/new BUFSIZE))
    (var header nil)
    (forever
      (buffer/clear linebuf)
      (file/read infile :line linebuf)
      (cond
        (zero? (length linebuf))
          (do
            (yield [header buf])
            (break))
        (= (in linebuf 0) (chr ">"))
          (do
            (when header
              (yield [header buf]))
              (set buf (buffer/new BUFSIZE))
              (set header linebuf)
              (set linebuf (buffer/new 128)))
        (do
          (buffer/popn linebuf 1)
          (buffer/push buf linebuf))))))


(defn main [& args]
  (def trans
    (maketrans
      "ACGTUMRWSYKVHDBNacgtumrwsykvhdbn"
      "TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN"))
  (def infile (file/open (in args 1)))
  (def outbuf (buffer/new BUFSIZE))

  (loop [[header sequence] :in (gen-sequences infile)]
    #(def sttime (os/clock))
    (file/write stdout header)

    # translate into outbuf, reversed, including nls
    (buffer/clear outbuf)
    (def ln (length sequence))
    (var nxr 60)
    (loop [i :range [0 ln]]
      (when (= i nxr)
        (buffer/push-byte outbuf 10)
        (+= nxr 60))
      (buffer/push-byte outbuf (in trans (in sequence (- ln i 1)))))
    # If you replace the above loop with this loop you can see that 80% of execution
    # time is in the translation part (the handling of each byte).
    #(loop [i :range [0 ln 60]]                      # 15s
    #  (def nd (min (+ i 60) ln))
    #  (buffer/blit outbuf buf i i nd))
    #(buffer/push outbuf (string/ascii-upper buf))   # 10s

    # print it out
    (if (not= 10 (in outbuf (dec (length outbuf))))
      (buffer/push-byte outbuf 10))
    (file/write stdout outbuf))
    #(print "TIME: " (- (os/clock) sttime))
    ))

