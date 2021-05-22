#lang scribble/manual

@require[@for-label[racket/base
                    covid-19/qq
                    covid-19/sina]
         scribble/eval]

@; @(define the-eval
@;    (make-eval-factory '(covid-19 racket/pretty)))
@(define the-eval
         (make-base-eval '(require covid-19 racket/pretty)
                         '(pretty-print-depth 0)))

@title{covid-19}
@author[@author+email["Yanying Wang" "yanyingwang1@gmail.com"]]
Racket wrapper of QQ/Sina's COVID-19 API

@defmodule[covid-19]
@smaller{@racket[(require covid)] will do the same as @racket[(require covid/qq covid/sina)].}

@section{QQ}
@defmodule[covid-19/qq]
@deftogether[(
@defthing[qq/data hash-eq?]
@defthing[qq/data/china-total hash-eq?]
@defthing[qq/data/china-add hash-eq?]
@defthing[qq/data/all-provinces list?]
)]{
Values that returned directly from requesting QQ's covid-19 API.
}

@defproc[(qq/get-province [name (or/c string? symbol?)]) hash-eq?]{
Returns data of a specified province @racket[name] of China.
@examples[#:eval the-eval
(qq/get-province '河南)
]
}

@defproc[(qq/get-num [node-data (hash-eq?)] [type1 (or/c 'confirm 'dead)] [type2 (or/c 'today 'total)]) number?]{
Returns a number of @racket[type1] in @racket[type2] of a @racket[node], which @racket[node] is the results of @racket[qq/get-province].
@examples[#:eval the-eval
(qq/get-num (qq/get-province '河南) 'confirm 'total)
]
}

@defproc[(qq/get-num*
                [province-name symbol?]
                [type1 (or/c 'confirm 'dead) 'confirm]
                [type2 (or/c 'today 'total) 'today]
                [#:city city-name string? #f]) number?]{
Returns a number of @racket[type1] in @racket[type2] of a specified @racket[city-name] of @racket[province-name].
@examples[#:eval the-eval
(qq/get-num* '河南)
(qq/get-num* '河南 'confirm 'total)
(qq/get-num* '河南 'confirm 'total #:city '郑州)
]}

@defproc[(qq/filter-by
                [type1 (or/c 'confirm 'dead)]
                [type2 (or/c 'today 'total)]) list?]{
Sorting and filting @racket[qq/data/all-provinces] by @racket[type1] and @racket[type2].
@examples[#:eval the-eval
(qq/filter-by 'confirm 'total)]
}


@section{Sina}
@defmodule[covid-19/sina]
@deftogether[(
@defthing[sina/data hash-eq?]
@defthing[sina/data/list list?]
@defthing[sina/data/otherlist list?]
)]{
Values that returned directly from requesting Sina's covid-19 API.
}

@defproc[(sina/contries/sort+filter-by
                [type (or/c 'conNum 'conadd 'deathNum 'deathadd)]) number?]{
Sorting and filting @racket[sina/data/otherlist] by @racket[type].
@examples[#:eval the-eval
(sina/contries/sort+filter-by 'conNum)]
}
