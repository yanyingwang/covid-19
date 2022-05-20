868
((3) 0 () 2 ((q lib "covid-19/qq.rkt") (q lib "covid-19/sina.rkt")) () (h ! (equal) ((c def c (c (? . 0) q qq/data/china-add)) q (197 . 2)) ((c def c (c (? . 0) q qq/data/all-provinces)) q (241 . 2)) ((c def c (c (? . 0) q qq/get-num*)) q (633 . 9)) ((c def c (c (? . 1) q sina/data/list)) q (1272 . 2)) ((c def c (c (? . 1) q sina/contries/sort+filter-by)) q (1353 . 3)) ((c def c (c (? . 0) q qq/data/china-total)) q (151 . 2)) ((c def c (c (? . 0) q qq/get-region)) q (286 . 4)) ((c def c (c (? . 0) q qq/sort+filter-by)) q (985 . 4)) ((c def c (c (? . 1) q covid-19/reload-data/sina)) q (1115 . 5)) ((c def c (c (? . 0) q qq/get-num)) q (442 . 5)) ((c def c (c (? . 1) q sina/data)) q (1236 . 2)) ((c def c (c (? . 1) q sina/data/otherlist)) q (1310 . 2)) ((c def c (c (? . 0) q covid-19/reload-data/qq)) q (0 . 5)) ((c def c (c (? . 0) q qq/data)) q (117 . 2))))
parameter
(covid-19/reload-data/qq) -> boolean?
(covid-19/reload-data/qq v) -> void?
  v : boolean?
 = #t
procedure
(qq/data) -> hash-eq?
procedure
(qq/data/china-total) -> hash-eq?
procedure
(qq/data/china-add) -> hash-eq?
procedure
(qq/data/all-provinces) -> list?
procedure
(qq/get-region province-name city-name) -> hash-eq?
  province-name : (or/c string? symbol?)
  city-name : (or/c string? symbol?)
procedure
(qq/get-num node-data [type1 type2]) -> number?
  node-data : (hash-eq?)
  type1 : (or/c 'confirm 'dead) = 'confirm
  type2 : (or/c 'today 'total) = 'today
procedure
(qq/get-num*  province-name          
             [type1                  
              type2                  
              #:city city-name]) -> number?
  province-name : symbol?
  type1 : (or/c 'confirm 'dead) = 'confirm
  type2 : (or/c 'today 'total) = 'today
  city-name : string? = #f
procedure
(qq/sort+filter-by type1 type2) -> list?
  type1 : (or/c 'confirm 'dead)
  type2 : (or/c 'today 'total)
parameter
(covid-19/reload-data/sina) -> boolean?
(covid-19/reload-data/sina v) -> void?
  v : boolean?
 = #t
procedure
(sina/data) -> hash-eq?
procedure
(sina/data/list) -> list?
procedure
(sina/data/otherlist) -> list?
procedure
(sina/contries/sort+filter-by type) -> number?
  type : (or/c 'conNum 'conadd 'deathNum 'deathadd)
