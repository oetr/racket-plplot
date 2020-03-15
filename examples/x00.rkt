#lang racket

(require ffi/unsafe
         plplot)

(define NSIZE 101)

(define x (make-vector NSIZE))
(define y (make-vector NSIZE))

(define xmin 0.0)
(define xmax 1.0)
(define ymin 0.0)
(define ymax 100.0)

(for ([i NSIZE])
  (define x_i (/ (+ i 0.0) (- NSIZE 1.0)))
  (vector-set! x i x_i)
  (vector-set! y i (* ymax x_i x_i)))

(c_plscolbga 255 255 255 0.1)
;; Initialize plplot
(c_plinit)


;; Create a labelled box to hold the plot.
(c_plenv xmin xmax ymin ymax 0 0)
(c_pllab "x" "y=100 x#u2#d" "Simple PLplot demo of a 2D line plot")

;; Plot the data that was prepared above.
(c_plline NSIZE
          (vector->cblock x _double)
          (vector->cblock y _double))

;; Close PLplot library
(c_plend)
