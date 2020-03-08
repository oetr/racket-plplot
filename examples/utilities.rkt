#lang racket
(require ffi/unsafe)
(provide (all-defined-out))

(define (->c data type)
  (vector->cblock data type))

(define (str-vec->c vec)
  (vector->cblock
   (vector-map
    (lambda (v)
      (list->cblock (append (map char->integer (string->list v))
                            '(0))
                    _byte))
    vec)
   _pointer))
