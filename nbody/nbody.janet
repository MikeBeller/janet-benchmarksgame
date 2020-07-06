
(def solar-mass (* 4 math/pi math/pi))
(def days-per-year 365.24)
(def bodies
[
  @{ # Sun
    :x 0
    :y 0
    :z 0
    :vx 0
    :vy 0
    :vz 0
    :mass solar-mass
  }
  @{ # Jupiter
    :x 4.84143144246472090e+00
    :y -1.16032004402742839e+00
    :z -1.03622044471123109e-01
    :vx (* 1.66007664274403694e-03 days-per-year)
    :vy (* 7.69901118419740425e-03 days-per-year)
    :vz (* -6.90460016972063023e-05 days-per-year)
    :mass (* 9.54791938424326609e-04 solar-mass)
  }
  @{ # Saturn
    :x 8.34336671824457987e+00
    :y 4.12479856412430479e+00
    :z -4.03523417114321381e-01
    :vx (* -2.76742510726862411e-03 days-per-year)
    :vy (* 4.99852801234917238e-03 days-per-year)
    :vz (* 2.30417297573763929e-05 days-per-year)
    :mass (* 2.85885980666130812e-04 solar-mass)
  }
  @{ # Uranus
    :x 1.28943695621391310e+01
    :y -1.51111514016986312e+01
    :z -2.23307578892655734e-01
    :vx (* 2.96460137564761618e-03 days-per-year)
    :vy (* 2.37847173959480950e-03 days-per-year)
    :vz (* -2.96589568540237556e-05 days-per-year)
    :mass (* 4.36624404335156298e-05 solar-mass)
  }
  @{ # Neptune
    :x 1.53796971148509165e+01
    :y -2.59193146099879641e+01
    :z 1.79258772950371181e-01
    :vx (* 2.68067772490389322e-03 days-per-year)
    :vy (* 1.62824170038242295e-03 days-per-year)
    :vz (* -9.51592254519715870e-05 days-per-year)
    :mass (* 5.15138902046611451e-05 solar-mass)
  }
])

(defn advance [bodies nbody dt]
  (loop [i :range [0 nbody]
         :let [bi (in bodies i)]]
    (loop [j :range [(inc i) nbody]
           :let [bj (in bodies j)]]
      (def dx (- (in bi :x) (in bj :x)))
      (def dy (- (in bi :y) (in bj :y)))
      (def dz (- (in bi :z) (in bj :z)))
      (def dist (math/sqrt (+ (* dx dx) (* dy dy) (* dz dz))))
      (def mag (/ dt (* dist dist dist)))
      (def bim (* (in bi :mass) mag))
      (def bjm (* (in bj :mass) mag))
      (-= (bi :vx) (* dx bjm))
      (-= (bi :vy) (* dy bjm))
      (-= (bi :vz) (* dz bjm))
      (+= (bj :vx) (* dx bim))
      (+= (bj :vy) (* dy bim))
      (+= (bj :vz) (* dz bim)))
    (+= (bi :x) (* dt (in bi :vx)))
    (+= (bi :y) (* dt (in bi :vy)))
    (+= (bi :z) (* dt (in bi :vz)))))


(defn energy [bodies nbody]
  (var e 0)
  (loop [i :range [0 nbody]
         :let [bi (in bodies i)]]
    (def vx (in bi :vx))
    (def vy (in bi :vy))
    (def vz (in bi :vz))
    (+= e (* 0.5 (in bi :mass) (+ (* vx vx) (* vy vy) (* vz vz))))
    (loop [j :range [(inc i) nbody]
           :let [bj (in bodies j)]]
      (def dx (- (in bi :x) (in bj :x)))
      (def dy (- (in bi :y) (in bj :y)))
      (def dz (- (in bi :z) (in bj :z)))
      (def dist (math/sqrt (+ (* dx dx) (* dy dy) (* dz dz))))
      (-= e (/ (* (in bi :mass) (in bj :mass)) dist))))
  e)

(defn offset-momentum [bodies nbody]
  (var px 0)
  (var py 0)
  (var pz 0)
  (each b bodies
    (def mass (in b :mass))
    (+= px (* (in b :vx) mass))
    (+= py (* (in b :vy) mass))
    (+= pz (* (in b :vz) mass)))
  (def sun (in bodies 0))
  (set (sun :vx) (/ (- px) solar-mass))
  (set (sun :vy) (/ (- py) solar-mass))
  (set (sun :vz) (/ (- pz) solar-mass)))

(def N (scan-number (get (dyn :args) 1)))
(def nbody (length bodies))
(offset-momentum bodies nbody)
(printf "%0.9f" (energy bodies nbody))
(for i 0 N (advance bodies nbody 0.01))
(printf "%0.9f" (energy bodies nbody))

