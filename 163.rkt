#lang racket/base


(require racket/list racket/port racket/format racket/string racket/provide
         http-client json)
(provide covid-19/reload-data/163
         (matching-identifiers-out #rx"^qq\\/.*" (all-defined-out)))


(define response '())
(define covid-19/reload-data/163 (make-parameter #t))

;; https://wp.m.163.com/163/page/news/virus_report/index.html
(define (do-request)
  (http-get "https://c.m.163.com/ug/api/wuhan/app/data/list-total"
            ;; #:path "/"
            ;; #:data (hasheq 'name "disease_h5")
            ))

(define (163/data)
  (and (or (covid-19/reload-data/163)
           (empty? response))
       (set! response (do-request))
       (covid-19/reload-data/163 #f))
  (hash-ref (http-response-body response) 'data))

(define (163/data/china-total) (hash-ref (163/data) 'chinaTotal))
(define (163/data/china-day-list) (hash-ref (163/data) 'chinaDayList))
(define (163/data/area-tree) (hash-ref (163/data) 'areaTree))

(define (163/get-country name)
  (for/first ([i (163/data/area-tree)]
              #:when (string=? (hash-ref i 'name) name))
    i))

(define (163/data/china)
  (163/get-country "中国"))
(define (163/data/china/provinces)
  (hash-ref (163/data/china) 'children))


(define (163/get-region name [city-name #f])
  (and (symbol? name)
       (set! name (symbol->string name)))
  (and (symbol? city-name)
       (set! city-name (symbol->string city-name)))
  (define province
    (findf (lambda (i) (equal? (hash-ref i 'name) name))
           (163/data/china/provinces)))
  (if city-name
      (findf (lambda (i) (equal? (hash-ref i 'name) city-name))
             (hash-ref province 'children))
      province))

(define (163/get-num node
                    [type1 'confirm]
                    [type2 'today])
  (if node
      (hash-ref (hash-ref node type2) type1)
      #f))

(define (163/get-num* province-name
                     #:city [city-name #f]
                     [type1 'confirm]
                     [type2 'today])
  (define region
    (163/get-region province-name city-name))
  (if region
      (hash-ref (hash-ref region type2) type1)
      #f))

(define (163/sort+filter-by type1 type2) ;; type1 <= { 'confirm 'dead } type2 <= { 'today 'total }
  (define sorted-provinces
    (sort (163/data/china/provinces)
          (lambda (i1 i2)
            (> (hash-ref (hash-ref i1 type2) type1)
               (hash-ref (hash-ref i2 type2) type1)))))
  (for/list ([i sorted-provinces])
    (cons (hash-ref i 'name)
          (hash-ref (hash-ref i 'today) 'confirm)))
  )
