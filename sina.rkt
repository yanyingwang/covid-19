#lang racket/base

(require racket/list racket/port racket/format racket/string racket/provide
         http-client)
(provide (matching-identifiers-out #rx"^sina\\/.*" (all-defined-out)))


;;;; sina.cn api
(define res
  (http-get "https://interface.sina.cn"
            #:path "news/wap/fymap2020_data.d.json"))

(define sina/data (hash-ref (http-response-body res) 'data))
(define sina/data/list (hash-ref sina/data 'list))
(define sina/data/otherlist (hash-ref sina/data 'otherlist))


(define (sina/contries/sort+filter-by type)
  (define sorted-contries
    (sort sina/data/otherlist
          (lambda (i1 i2)
            (define v1 (hash-ref i1 'value))
            (define v2 (hash-ref i2 'value))
            (and (string=? v1 "-") (set! v1 "-1"))
            (and (string=? v2 "-") (set! v2 "-1"))
            (> (string->number v1)
               (string->number v2)))))
  (for/list ([i sorted-contries])
    (cons (hash-ref i 'name)
          (string->number (hash-ref i type)))))
