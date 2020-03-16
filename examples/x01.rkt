#lang racket

(require ffi/unsafe
         "../main.rkt")


(define *x* (make-vector 101))
(define *y* (make-vector 101))
(define *xs* (make-vector 6))
(define *ys* (make-vector 6))

(define (->c data type)
  (vector->cblock data type))

(define (plot1 xscale yscale xoff yoff)
  (define n 60)
  (for ([i n])
    (define x-val (+ xoff (/ (* xscale (+ i 1.0)) n)))
    (define y-val (+ yoff (* yscale (expt x-val 2.0))))
    (vector-set! *x* i x-val)
    (vector-set! *y* i y-val))
  
  (define xmin (vector-ref *x* 0))
  (define xmax (vector-ref *x* (- n 1)))
  (define ymin (vector-ref *y* 0))
  (define ymax (vector-ref *y* (- n 1)))

  (for ([i 6])
    (vector-set! *xs* i (vector-ref *x* (+ (* i 10) 3)))
    (vector-set! *ys* i (vector-ref *y* (+ (* i 10) 3))))

  (define x (->c *x* PLFLT))
  (define y (->c *y* PLFLT))
  (define xs (->c *xs* PLFLT))
  (define ys (->c *ys* PLFLT))

  ;; Set up the viewport and window using PLENV. The range in X is
  ;; 0.0 to 6.0, and the range in Y is 0.0 to 30.0. The axes are
  ;; scaled separately (just = 0), and we just draw a labelled
  ;; box (axis = 0).
  ;;
  (c_plcol0 1)
  (c_plenv xmin xmax ymin ymax 0 0)
  (c_plcol0 2)
  (c_pllab "(x)" "(y)" "#frPLplot Example 1 - y=x#u2")

  ;; Plot the data points
  (c_plcol0 4)
  (c_plpoin 6 xs ys 9)
  ;; Draw the line through the data
  (c_plcol0 3)
  (c_plline 60 x y)

  ;; xor mode enable erasing a line/point/text by replotting it again
  ;; it does not work in double buffering mode, however
  (define status (c_plxormod 1)) ;; enter xor mode
  (printf "status: ~a~n" status)
  (unless (zero? status)
    (for ([i 60])
      (c_plpoin 1
                (ptr-add x i PLFLT)
                (ptr-add y i PLFLT) 9) ;; draw a point
      (sleep 0.0001)
      (c_plflush) ;; force an update of the tk driver
      (c_plpoin 1
                (ptr-add x i PLFLT)
                (ptr-add y i PLFLT) 9)) ;; erase point
    ;; leave xor mode
    (set! status (c_plxormod 0)))
  )

(define (plot2)
  ;; Set up the viewport and window using PLENV. The range in X is -2.0 to
  ;; 10.0, and the range in Y is -0.4 to 2.0. The axes are scaled separately
  ;; (just = 0), and we draw a box with axes (axis = 1).
  ;;
  (c_plcol0 1)
  (c_plenv -2.0 10.0 -0.4 1.2 0 1)
  (c_plcol0 2)
  (c_pllab "(x)" "sin(x)/x" "#frPLplot Example 1 - Sinc Function")

  ;; Fill up the arrays
  (for ([i 100])
    (vector-set! *x* i (/ (- i 19.0) 6.0))
    (vector-set! *y* i 1.0)
    (define x_i (vector-ref *x* i))
    (unless (= 0.0 x_i)
      (vector-set! *y* i (/ (sin x_i) x_i))))


  (define x (->c *x* PLFLT))
  (define y (->c *y* PLFLT))

  ;; Draw the line
  (c_plcol0 3)
  (c_plwidth 2)
  (c_plline 100 x y)
  (c_plwidth 1 ))


(define (plot3)
  (define space0 0)
  (define mark0  0)
  (define space1 1500)
  (define mark1  1500)
  ;; For the final graph we wish to override the default tick intervals, and
  ;; so do not use plenv().
  ;;
  (c_pladv 0)

  ;; Use standard viewport, and define X range from 0 to 360 degrees, Y range
  ;; from -1.2 to 1.2.
  ;;
  (c_plvsta)
  (c_plwind 0.0 360.0 -1.2 1.2)

  ;; Draw a box with ticks spaced 60 degrees apart in X, and 0.2 in Y.
  (c_plcol0 1)
  (c_plbox "bcnst" 60.0 2 "bcnstv" 0.2 2)

  ;; Superimpose a dashed line grid, with 1.5 mm marks and spaces.
  ;; plstyl expects a pointer!
  ;;
  (c_plstyl 1 mark1 space1)
  (c_plcol0 2)
  (c_plbox "g" 30.0 0 "g" 0.2 0)
  (c_plstyl 0 mark0 space0)

  (c_plcol0 3)
  (c_pllab "Angle (degrees)" "sine" "#frPLplot Example 1 - Sine function")

  (for ([i 101])
    (define x_i (* 3.6 i))
    (vector-set! *x* i x_i)
    (vector-set! *y* i (sin (/ (* x_i pi) 180.0))))

  (define x (->c *x* PLFLT))
  (define y (->c *y* PLFLT))
  (c_plcol0 4)
  (c_plline 101 x y))



;; (define fontset 1)
(define ver (c_plgver))
(printf "PLplot library version: ~a~n" ver)
;; Initialize plplot
;; Divide page into 2x2 plots
;; Note: calling plstar replaces separate calls to plssub and plinit
(for ([i 100])
  (c_plscol0 i 0 0 0))

(c_plscolbga 240 240 240 1.0)
(c_plstar 2 2)

;; Select font set as per input flag
(c_plfontld 1)

;; Set up the data
;; Original case
(define xscale 6.0)
(define yscale 1.0)
(define xoff   0.0)
(define yoff   0.0)

;; Do a plot
(plot1 xscale yscale xoff yoff)

;; Set up the data
(set! xscale 1.0)
(set! yscale 0.0014)
(set! yoff   0.0185)
;; Do a plot
(define digmax 5)
(c_plsyax digmax 0)

(plot1 xscale yscale xoff yoff)
(plot2)
(plot3)

;;
;; Show how to save a plot:
;; Open a new device, make it current, copy parameters,
;; and replay the plot buffer
;;
;; this works well when backend is xwindow
;; evrything else seems to doubl-plot all text
(define f-name "x01.pdf")
(printf "The current plot was saved in color Postscript under the name '~a'\n"
        f-name)

(define cur-strm (c_plgstrm))    ;; get current stream
(define new-strm (c_plmkstrm))   ;; create a new one
(printf "current: ~a, new: ~a\n" cur-strm new-strm)

(c_plsfnam f-name)       ;; file name
(c_plsdev "pdfqt" )       ;; device type

(c_plcpstrm cur-strm 0) ;; copy old stream parameters to new stream
(c_plreplot)            ;; do the save by replaying the plot buffer

(c_plend1)              ;; finish the device
(c_plsstrm cur-strm)    ;; return to previous stream

(define-values (status gin) (plGetCursor))
(printf "~a, ~a~n" status gin)
(printf "~a~n" (PLGraphicsIn-keysym gin))

;; don't use this with cairo in plplot version 5.10.0
;; this causes a buffer overflow
(let loop ()
  (set! status (plGetCursor gin))
  (printf "status: ~a~n" status)
  (unless (= (char->integer #\q) (PLGraphicsIn-keysym gin))
    (unless (zero? status)
      (c_pltext)
      ;;(sleep 0.001)
      (printf "subwin = ~a, wx = ~a,  wy = ~a, dx = ~a,  dy = ~a\n"
              (PLGraphicsIn-subwindow gin)
              (PLGraphicsIn-wX gin)
              (PLGraphicsIn-wY gin)
              (PLGraphicsIn-dX gin)
              (PLGraphicsIn-dY gin))
      (printf "keysym = ~a, button = ~a, string = '~a', type = ~a, state = ~a\n"
              (PLGraphicsIn-keysym gin)
              (PLGraphicsIn-button gin)
              (PLGraphicsIn-string gin)
              (PLGraphicsIn-type gin)
              (PLGraphicsIn-state gin))
      (c_plgra))
    (loop)))

(c_plend)
