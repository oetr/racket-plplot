#lang racket
;;      Multiple window and color map 0 demo.
;;

(require ffi/unsafe
         "../main.rkt")

;;--------------------------------------------------------------------------
;; draw_windows
;;
;; Draws a set of numbered boxes with colors according to cmap0 entry.
;;--------------------------------------------------------------------------
(define (draw-windows nw cmap0-offset)
  (c_plschr 0.0 3.5) ;; character height
  (c_plfont 4) ;; choose font 4

  (for ([i nw])
    (c_plcol0 (+ i cmap0-offset)) ;; set color map
    (c_pladv 0) ;; advance to the next page
    (define vmin 0.1)
    (define vmax 0.9)

    (for ([j 3])
      (c_plwidth (+ j 1)) ;; set pen width
      (c_plvpor vmin vmax vmin vmax) ;; create viewport (vp)
      (c_plwind 0.0 1.0 0.0 1.0) ;; world coordinates for vp boundaries
      (c_plbox "bc" 0.0 0 "bc" 0.0 0) ;; draw box around vp
      (set! vmin (+ vmin 0.1))
      (set! vmax (- vmax 0.1)))


    (define text (number->string i))
    (c_plwidth 1)
    (c_plptex 0.5 0.5 1.0 0.0 0.5 text)))


;;--------------------------------------------------------------------------
;; demo1
;;
;; Demonstrates multiple windows and default color map 0 palette.
;;--------------------------------------------------------------------------
(define (demo1)
  (c_plbop)
  ;; Divide screen into 16 regions
  (c_plssub 4 4)
  (draw-windows 16 0)
  (c_pleop))

;;--------------------------------------------------------------------------
;; demo2
;;
;; Demonstrates multiple windows, user-modified color map 0 palette, and
;; HLS -> RGB translation.
;;--------------------------------------------------------------------------
(define (demo2)
  (define (~f n)
    (~r #:precision '(= 5)
        #:min-width 10
        n))
  
  ;; Set up cmap0
  ;; Use 100 custom colors in addition to base 16
  (define r (make-vector 116))
  (define g (make-vector 116))
  (define b (make-vector 116))

  ;; Min & max lightness values
  (define lmin 0.15)
  (define lmax 0.85)
  (c_plbop)
  
  ;; Divide screen into 100 regions
  (c_plssub 10 10)
  (for ([i 100])
    ;; Bounds on HLS, from plhlsrgb() commentary --
    ;;	hue		[0., 360.]	degrees
    ;;	lightness	[0., 1.]	magnitude
    ;;	saturation	[0., 1.]	magnitude
    ;;

    ;; Vary hue uniformly from left to right
    (define h (* (/ 360. 10.) (modulo i 10)))
    ;; Vary lightness uniformly from top to bottom, between min & max
    (define l (+ lmin (* (- lmax lmin)  (/ (floor (/ i 10)) 9.0))))
    ;; Use max saturation
    (define s 1.0)

    (define-values (r1 g1 b1) (c_plhlsrgb h l s))
    (printf "~a: ~a ~a ~a ~a ~a ~a \n" (~r (+ i 16) #:min-width 4)
            (~f h) (~f l) (~f s)
            (~f r1)(~f g1)(~f b1))

    ;; Use 255.001 to avoid close truncation decisions in this example.
    (vector-set! r (+ i 16) (inexact->exact (floor (* r1 255))))
    (vector-set! g (+ i 16) (inexact->exact (floor (* g1 255))))
    (vector-set! b (+ i 16) (inexact->exact (floor (* b1 255)))))


  ;;(pretty-print r)
  ;; Load default cmap0 colors into our custom set
  (for ([i 16])
    (define-values (r1 g1 b1) (c_plgcol0 i))
    (vector-set! r i r1)
    (vector-set! g i g1)
    (vector-set! b i b1))


  ;; Now set cmap0 all at once (faster, since fewer driver calls)
  (c_plscmap0 (vector->cblock r PLINT)
              (vector->cblock g PLINT)
              (vector->cblock b PLINT)
              116)

  (draw-windows 100 16)

  (c_pleop))


;;--------------------------------------------------------------------------
;; main
;;
;; Demonstrates multiple windows and color map 0 palette, both default and
;; user-modified.
(c_plinit)
(demo1)
(demo2)
(c_plend)

