#lang racket
;;      Polar plot demo
;;
;; Generates polar plot, with 1-1 scaling.

(require ffi/unsafe
         "utilities.rkt"
         "../plplot.rkt")


(define x0 (make-vector 361))
(define y0 (make-vector 361))
(define x (make-vector 361))
(define y (make-vector 361))
(define dtr (/ pi 180.0))

(for ([i 100])
  (c_plscol0 i 0 0 0))

(c_plscolbga 255 255 255 1.0)


(for ([i 361])
  (vector-set! x0 i (cos (* dtr i)))
  (vector-set! y0 i (sin (* dtr i))))


;; Set orientation to portrait - note not all device drivers
;; support this, in particular most interactive drivers do not
(c_plsori 1)

;; Initialize plplot

(c_plscolbga 255 255 255 0.1)
(c_plinit)

;; Set up viewport and window, but do not draw box

(c_plenv -1.3 1.3 -1.3 1.3 1 -2)
;; Draw circles for polar grid

(for ([i (range 1 11)])
  (c_plarc 0.0 0.0 (* i 0.1) (* i 0.1) 0.0 360.0 0.0 0))
  
(c_plcol0 2)

(define offset 0.0)
(for ([i (range 1 11)])
  (define theta (* 30.0 i))
  (define dx (cos (* dtr theta)))
  (define dy (sin (* dtr theta)))
  ;; Draw radial spokes for polar grid

  (c_pljoin 0.0 0.0 dx dy)
  (define text (~a (round theta)))
  
  ;; Write labels for angle
  (cond [(< theta 9.99) (set! offset 0.45)]
        [(< theta 99.9) (set! offset 0.30)]
        [else (set! offset 0.15)])

  ;; Slightly off zero to avoid floating point logic flips at 90 and 270 deg.
  (if (> dx -0.00001)
      (c_plptex dx dy dx dy (- offset) text)
      (c_plptex dx dy (- dx) (- dy) (+ 1.0 offset) text)))


;; Draw the graph
(for ([i 361])
  (define r (sin (* dtr 5 i)))
  (vector-set! x i (* r (vector-ref x0 i)))
  (vector-set! y i (* r (vector-ref y0 i))))


(c_plcol0 3)
(c_plline 361 (->c x PLFLT) (->c y PLFLT))

(c_plcol0 4)
(c_plmtex "t" 2.0 0.5 0.5 "#frPLplot Example 3 - r(#gh)=sin 5#gh")
  ;; Close the plot at end
(c_plend)
(exit 0)
