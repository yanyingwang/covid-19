#lang at-exp racket/base

(require racket/list racket/port racket/format racket/string racket/provide
         http-client json
         (file "parameters.rkt")
         (file "tools.rkt"))
(provide (matching-identifiers-out #rx"^qq\\/.*" (all-defined-out)))


(define res
  (http-get "https://view.inews.qq.com"
            #:path "/g2/getOnsInfo"
            #:data (hasheq 'name "disease_h5")))
(define data
  (string->jsexpr (hash-ref (http-response-body res) 'data)))
(define china-total (hash-ref data 'chinaTotal))
(define china-add (hash-ref data 'chinaAdd))
(define all-provinces (hash-ref (car (hash-ref data 'areaTree)) 'children))


;;;;;;; helpers
(define (qq/get-num node type1 type2)
  (if node
      (hash-ref (hash-ref node type1) type2)
      #f))

(define (qq/get-num* prov-name
                     #:city [city-name #f]
                     [type1 'confirm]
                     [type2 'today])
  (define province (qq/get-province prov-name city-name))
  (if province
      (hash-ref (hash-ref province type2) type1)
      #f))

(define (qq/filter-by type1 type2) ;; type1 <= { 'today 'total } type2 <= { 'confirm 'dead }
  (define sorted-provinces
    (sort all-provinces
          (lambda (i1 i2)
            (> (hash-ref (hash-ref i1 type1) type2)
               (hash-ref (hash-ref i2 type1) type2)))))
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
                          all-provinces))
  (if city-name
      (findf (lambda (i)
           (equal? (hash-ref i 'name) city-name))
             (hash-ref province 'children))
      province)
  )

