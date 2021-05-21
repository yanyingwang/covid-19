#lang at-exp racket/base

(require racket/list racket/port racket/format racket/string racket/provide
         http-client json)
(provide (matching-identifiers-out #rx"^sina\\/.*" (all-defined-out)))


;;;; sina.cn api
(define res
  (http-get "https://interface.sina.cn"
            #:path "news/wap/fymap2020_data.d.json"))

(define data (hash-ref (http-response-body res) 'data))
(define data/list (hash-ref data 'list))
(define data/otherlist (hash-ref data 'otherlist))

;;;;;;;
(define henan (findf (lambda (i) (equal? (hash-ref i 'name) "河南"))
                     data/list))
(define zhengzhou (findf (lambda (i) (equal? (hash-ref i 'name) "郑州市"))
                         (hash-ref henan 'city)))


(define (sina/contries/filter-by column-name)
  (define sorted-contries
    (sort data/otherlist
          (lambda (i1 i2)
            (define v1 (hash-ref i1 'value))
            (define v2 (hash-ref i2 'value))
            (and (string=? v1 "-") (set! v1 "-1"))
            (and (string=? v2 "-") (set! v2 "-1"))
            (> (string->number v1)
               (string->number v2)))))
  (for/list ([i sorted-contries])
    (cons (hash-ref i 'name)
          (string->number (hash-ref i column-name)))))

