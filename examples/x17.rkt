;; Plots a simple stripchart with four pens.
#lang racket

(require ffi/unsafe
         plplot
         "utilities.rkt")

(define nsteps 10000)

;;--------------------------------------------------------------------------
;; main program
;;--------------------------------------------------------------------------

;; If db is used the plot is much more smooth. However, because of the
;; async X behaviour, one does not have a real-time scripcharter.
;; This is now disabled since it does not significantly improve the
;; performance on new machines and makes it difficult to use this
;; example non-interactively since it requires an extra pleop call after
;; each call to plstripa.
;;
;;plsetopt("db", "");
;;plsetopt("np", "");

;; User sets up plot completely except for window and data
;; Eventually settings in place when strip chart is created will be
;; remembered so that multiple strip charts can be used simultaneously.
;;

;; Specify some reasonable defaults for ymin and ymax
;; The plot will grow automatically if needed (but not shrink)
(define ymin -0.1)
(define ymax  0.1)

;; Specify initial tmin and tmax -- this determines length of window.
;; Also specify maximum jump in t
;; This can accomodate adaptive timesteps
(define tmin 0.0)
(define tmax 10.0)
(define tjump 0.3)        ;; percentage of plot to jump

;; Axes options same as plbox.
;; Only automatic tick generation and label placement allowed
;; Eventually I'll make this fancier

(define colbox 1)
(define collab 3)

(define styline (vector 2 3 4 5)) ;; pens line style
(define colline (vector 2 3 4 5)) ;; pens color
(define legline (vector "sum" "sin" "sin*noi" "sin*noi")) ;; pens legend

(define xlab 0.0)
(define ylab 0.25)     ;; legend position

(define autoy 1)                  ;; autoscale y
(define acc   1)                  ;; don't scrip, accumulate

;; Initialize plplot

(c_plinit)

(c_pladv 0)
(c_plvsta)

;; Register our error variables with PLplot
;; From here on, we're handling all errors here

;;plsError( &pl_errcode, errmsg );

(define id1 (c_plstripc "bcnst" "bcnstv"
                        tmin tmax tjump ymin ymax
                        xlab ylab
                        autoy acc
                        colbox collab
                        (->c colline PLINT)
                        (->c styline PLINT)
                        (str-vec->c legline)
                        "t" "" "Strip chart demo"))

;; Let plplot handle errors from here on

(set! autoy 0)  ;; autoscale y
(set! acc   1)  ;; accumulate

;; This is to represent a loop over time
;; Let's try a random walk process
(define y1 0.0)
(define y2 0.0)
(define y3 0.0)
(define y4 0.0)
(define dt 0.1)

(define t 0.0)

(define noise 0.0)

(for ([n nsteps])
  (set! t (* n dt))
  (set! noise (- (random) 0.5))
  (set! y1 (+ y1 noise))
  (set! y2 (sin (/ (* t pi) 18.0)))
  (set! y3 (* y2 noise))
  (set! y4 (+ y2 (/ noise 3.0)))

  ;; There is no need for all pens to have the same number of
  ;; points or beeing equally time spaced.
  (cond [(not (zero? (modulo n 2)))
         (c_plstripa id1 0 t y1)]
        [(not (zero? (modulo n 3)))
         (c_plstripa id1 1 t y2)]
        [(not (zero? (modulo n 4)))
         (c_plstripa id1 2 t y3)]
        [(not (zero? (modulo n 5)))
         (c_plstripa id1 3 t y4)]))

;; needed if using double buffering (-db on command line)
;;pleop();

;; Destroy strip chart and it's memory

(c_plstripd id1)
(c_plend)
