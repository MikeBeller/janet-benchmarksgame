
(defn maketrans [a b]
  (def r @[])
  (loop [i :range [0 (length a)]]
    (put r (in a i) (in b i)))
  r)

(def BUFSIZE (* 1024 1024))

(defn main [& args]
  (def trans
    (maketrans
      "ACGTUMRWSYKVHDBNacgtumrwsykvhdbn"
      "TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN"))
  (def infile (file/open (in args 1)))
  (def outbufs @[])
  (def linebuf (buffer/new 128))
  (def buf (buffer/new BUFSIZE))
  (def outbuf (buffer/new BUFSIZE))
  (file/read infile :line linebuf)
  (while (not= 0 (length linebuf))
    (file/write stdout linebuf)
    (buffer/clear linebuf)
    (buffer/clear buf)

    # accumulate sequence into buf
    (forever
             (file/read infile :line linebuf)
             (when (or (zero? (length linebuf)) (= (in linebuf 0) (chr ">")))
               (break))

             (buffer/popn linebuf 1)  # the newline
             (buffer/push buf linebuf)
             (buffer/clear linebuf))

    # translate into outbuf, reversed, including nls
    (buffer/clear outbuf)
    (def ln (length buf))
    (var nxr 60)
    (loop [i :range [0 ln]]
      (when (= i nxr)
        (buffer/push-byte outbuf 10)
        (+= nxr 60))
      (buffer/push-byte outbuf (in trans (in buf (- ln i 1)))))
    # If you replace the above loop with this loop you can see that 80% of execution
    # time is in the translation part (the handling of each byte).
    #(loop [i :range [0 ln 60]]
    #  (def nd (min (+ i 60) ln))
    #  (buffer/blit outbuf buf i i nd))

    # print it out
    (if (not= 10 (in outbuf (dec (length outbuf))))
      (buffer/push-byte outbuf 10))
    (file/write stdout outbuf))
  )


