#lang info
(define collection "covid-19")
(define deps '("base" "at-exp-lib http-client"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/covid-19.scrbl" ())))
(define pkg-desc "Racket wrapper of QQ/Sina COVID-19 API ")
(define version "0.1")
(define pkg-authors '("Yanying Wang"))
