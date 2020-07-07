
(def solar-mass (* 4 math/pi math/pi))
(def days-per-year 365.24)
(def bodies-table
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

(def X 0)
(def Y 1)
(def Z 2)
(def VX 3)
(def VY 4)
(def VZ 5)
(def MASS 6)

# Bind bodies to be a set of arrays
(def bodies
  (seq [b :in bodies-table]
    (seq [k :in [:x :y :z :vx :vy :vz :mass]]
      (in b k))))

(defn advance [bodies nbody dt]
  (loop [i :range [0 nbody]
         :let [bi (in bodies i)
               [bix biy biz bivx bivy bivz bimass] bi]]
    (var bivx bivx)
    (var bivy bivy)
    (var bivz bivz)
    (loop [j :range [(inc i) nbody]
           :let [bj (in bodies j)
               [bjx bjy bjz bjvx bjvy bjvz bjmass] bj]]
      (def dx (- bix bjx))
      (def dy (- biy bjy))
      (def dz (- biz bjz))
      (def dist (math/sqrt (+ (* dx dx) (* dy dy) (* dz dz))))
      (def mag (/ dt (* dist dist dist)))
      (def bim (* bimass mag))
      (def bjm (* bjmass mag))
      (-= bivx (* dx bjm))
      (-= bivy (* dy bjm))
      (-= bivz (* dz bjm))
      (+= (bj VX) (* dx bim))
      (+= (bj VY) (* dy bim))
      (+= (bj VZ) (* dz bim)))
    (set (bi VX) bivx)
    (set (bi VY) bivy)
    (set (bi VZ) bivz))
  (each bi bodies
    (+= (bi X) (* dt (in bi VX)))
    (+= (bi Y) (* dt (in bi VY)))
    (+= (bi Z) (* dt (in bi VZ)))))

(defn energy [bodies nbody]
  (var e 0)
  (loop [i :range [0 nbody]
         :let [bi (in bodies i)
               [bix biy biz bivx bivy bivz bimass] bi]]
    (+= e (* 0.5 bimass (+ (* bivx bivx) (* bivy bivy) (* bivz bivz))))
    (loop [j :range [(inc i) nbody]
           :let [bj (in bodies j)]]
      (def dx (- bix (in bj X)))
      (def dy (- biy (in bj Y)))
      (def dz (- biz (in bj Z)))
      (def dist (math/sqrt (+ (* dx dx) (* dy dy) (* dz dz))))
      (-= e (/ (* bimass (in bj MASS)) dist))))
  e)

(defn offset-momentum [bodies nbody]
  (var px 0)
  (var py 0)
  (var pz 0)
  (each b bodies
    (def bimass (in b MASS))
    (+= px (* (in b VX) bimass))
    (+= py (* (in b VY) bimass))
    (+= pz (* (in b VZ) bimass)))
  (def sun (in bodies 0))
  (set (sun VX) (/ (- px) solar-mass))
  (set (sun VY) (/ (- py) solar-mass))
  (set (sun VZ) (/ (- pz) solar-mass)))

(def N (scan-number (get (dyn :args) 1)))
(def nbody (length bodies))
(offset-momentum bodies nbody)
(printf "%0.9f" (energy bodies nbody))
(for i 0 N 
  (advance bodies nbody 0.01))
(printf "%0.9f" (energy bodies nbody))

