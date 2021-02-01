
(defn maketrans [a b]
  (def r @[])
  (loop [i :range [0 (length a)]]
    (put r (in a i) (in b i)))
  r)

(def BUFSIZE (* 1024 1024))
(def SLICE keyword/slice)

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

(defn make-trans-table [trans chrs nd]
  (def myslice SLICE)
  (def tb @{})
  (def nc (length chrs))
  (def cnt (buffer/new-filled nd 0))
  (def kbuf (buffer/new nd))
  (def vbuf (buffer/new nd))
  (loop [i :range [0 (math/pow nc nd)]]
    (var j 0)
    (while (< j nd)
      (def n (inc (in cnt j)))
      (if (< n nc)
        (do
          (put cnt j n)
          (break))
        (do
          (put cnt j 0)
          (++ j))))
    (buffer/clear kbuf)
    (buffer/clear vbuf)
    (loop [j :range [0 nd]]
      (def ch (in chrs (in cnt j)))
      (buffer/push-byte kbuf ch)
      (buffer/push-byte vbuf (in trans ch)))
    (reverse! vbuf)
    (put tb (myslice kbuf) (myslice vbuf)))
  tb)

(defn trans-seg [trans sq]
  (def ln (length sq))
  (def buf (buffer/new ln))
  (loop [i :range [0 ln]]
    (buffer/push-byte buf (in trans (in sq (- ln i 1)))))
  buf)

(defn main [& args]
  (def myslice SLICE)
  (def filepath (in args 1))
  (def window (scan-number (get args 2 "2")))
  (def trans
    (maketrans
      "ACGTUMRWSYKVHDBNacgtumrwsykvhdbn"
      "TGCAAKYWSRMBDHVNTGCAAKYWSRMBDHVN"))
  #(def trseq
  #  (make-trans-table trans "ACGT" window))
  (def trseq @{})

  (def infile (file/open filepath))
  (def outbuf (buffer/new BUFSIZE))

  (loop [[header sequence] :in (gen-sequences infile)]
    (def sttime (os/clock))
    (file/write stdout header)

    # translate into outbuf, reversed, including nls
    (def sequence (string/ascii-upper sequence))
    (buffer/clear outbuf)
    (def ln (length sequence))
    (var nxr 60)
    (assert (zero? (% 60 window)) "invalid window")
    (loop [i :range [0 ln window]]
      (when (= i nxr)
        (buffer/push-byte outbuf 10)
        (+= nxr 60))
      (if (<= i (- ln window))
        (do
          (def sl (myslice sequence (- ln i window) (- ln i)))
          (def tr (in trseq sl))
          (if tr
            (buffer/push outbuf tr)
            (do
              (def trs (trans-seg trans sl))
              (put trseq sl trs)
              (buffer/push outbuf trs))))
        (do
          (buffer/push outbuf (trans-seg trans (myslice sequence 0 (- ln i))))
          (break))))

    # print it out
    (if (not= 10 (in outbuf (dec (length outbuf))))
      (buffer/push-byte outbuf 10))
    (file/write stdout outbuf)
    #(print "TIME: " (- (os/clock) sttime))
    )
  )

