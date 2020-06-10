
(defn read-seq []
  (loop [line :iterate (file/read stdin :line)
         :until (string/has-prefix? ">THREE " line)])
  (string/ascii-upper
    (string/join
      (seq [line :iterate (file/read stdin :line)
            :until (= (line 0) (chr ">"))]
        (string/trimr line)))))

(print (read-seq))


