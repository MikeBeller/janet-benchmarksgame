
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
    (def buf (string/ascii-upper buf))
    (def ln (length buf))
    #(var nxr 60)
    (var t 0)
    (var acgt 0)
    (loop [i :range [0 ln 4]]
      (def s (string/slice buf i (+ i 4)))
      (if (string/check-set "ACGT" s)
        (++ acgt))
      (++ t))

    # print it out
    (print t " " acgt)
  ))
