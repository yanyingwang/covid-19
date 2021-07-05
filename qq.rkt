#lang racket/base

(require racket/list racket/port racket/format racket/string racket/provide
         http-client json)
(provide covid-19/reload-data/qq
         (matching-identifiers-out #rx"^qq\\/.*" (all-defined-out)))




(define response '())
(define covid-19/reload-data/qq (make-parameter #t))

(define (do-request)
  (http-get "https://view.inews.qq.com"
            #:path "/g2/getOnsInfo"
            #:data (hasheq 'name "disease_h5")))

(define (qq/data)
  (and (or (covid-19/reload-data/qq)
           (empty? response))
       (set! response (do-request))
       (covid-19/reload-data/qq #f))
  (string->jsexpr (hash-ref (http-response-body response) 'data)))

(define (qq/data/china-total) (hash-ref (qq/data) 'chinaTotal))
(define (qq/data/china-add) (hash-ref (qq/data) 'chinaAdd))
(define (qq/data/all-provinces) (hash-ref (car (hash-ref (qq/data) 'areaTree)) 'children))


(define (qq/get-region name [city-name #f])
  (and (symbol? name)
       (set! name (symbol->string name)))
  (and (symbol? city-name)
       (set! city-name (symbol->string city-name)))
  (define province
    (findf (lambda (i) (equal? (hash-ref i 'name) name))
           (qq/data/all-provinces)))
  (if city-name
      (findf (lambda (i) (equal? (hash-ref i 'name) city-name))
             (hash-ref province 'children))
      province))

(define (qq/get-num node
                    [type1 'confirm]
                    [type2 'today])
  (if node
      (hash-ref (hash-ref node type2) type1)
      0))

(define (qq/get-num* province-name
                     #:city [city-name #f]
                     [type1 'confirm]
                     [type2 'today])
  (define region
    (qq/get-region province-name city-name))
  (if region
      (hash-ref (hash-ref region type2) type1)
      0))

(define (qq/sort+filter-by type1 type2) ;; type1 <= { 'confirm 'dead } type2 <= { 'today 'total }
  (define sorted-provinces
    (sort (qq/data/all-provinces)
          (lambda (i1 i2)
            (> (hash-ref (hash-ref i1 type2) type1)
               (hash-ref (hash-ref i2 type2) type1)))))
  (for/list ([i sorted-provinces])
    (cons (hash-ref i 'name)
          (hash-ref (hash-ref i 'today) 'confirm)))
  )
