

(defn task [parent]
  (def n (thread/receive math/inf))
  (def tab (thread/receive math/inf))
  (def r ((in tab n)))
  (thread/send parent r))

(defn helper [n]
  (in [:a :b :c] n))

(defmacro gen-fn [n]
  ~(fn [] ,(helper n)))

(def tab
  (seq [i :range [0 3]]
    (eval ~(gen-fn ,i))))

#(def tab @[ (fn [] :a) (fn [] :b) (fn [] :c)])

(def th (thread/new task))
(thread/send th 1)
(thread/send th tab)
(def r (thread/receive math/inf))
(pp r)

