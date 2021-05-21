#lang racket/base

(require racket/list racket/port racket/format racket/string racket/provide
         http-client json)
(provide (matching-identifiers-out #rx"^qq\\/.*" (all-defined-out)))


(define res
  (http-get "https://view.inews.qq.com"
            #:path "/g2/getOnsInfo"
            #:data (hasheq 'name "disease_h5")))

(define qq/data
  (string->jsexpr (hash-ref (http-response-body res) 'data)))
(define qq/data/china-total (hash-ref qq/data 'chinaTotal))
(define qq/data/china-add (hash-ref qq/data 'chinaAdd))
(define qq/data/all-provinces (hash-ref (car (hash-ref qq/data 'areaTree)) 'children))


;;;;;;; helpers
(define (qq/get-num node type1 type2)
  (if node
      (hash-ref (hash-ref node type2) type1)
      #f))

(define (qq/get-num* prov-name
                     #:city [city-name #f]
                     [type1 'confirm]
                     [type2 'today])
  (define province (qq/get-province prov-name city-name))
  (if province
      (hash-ref (hash-ref province type2) type1)
      #f))

(define (qq/filter-by type1 type2) ;; type1 <= { 'confirm 'dead } type2 <= { 'today 'total }
  (define sorted-provinces
    (sort qq/data/all-provinces
          (lambda (i1 i2)
            (> (hash-ref (hash-ref i1 type2) type1)
               (hash-ref (hash-ref i2 type2) type1)))))
  (for/list ([i sorted-provinces])
    (cons (hash-ref i 'name)
          (hash-ref (hash-ref i 'today) 'confirm)))
  )

(define (qq/get-province name [city-name #f])
  (and (symbol? name)
       (set! name (symbol->string name)))
  (and (symbol? city-name)
       (set! city-name (symbol->string city-name)))
  (define province (findf (lambda (i)
                            (equal? (hash-ref i 'name) name))
                          qq/data/all-provinces))
  (if city-name
      (findf (lambda (i)
           (equal? (hash-ref i 'name) city-name))
             (hash-ref province 'children))
      province)
  )

