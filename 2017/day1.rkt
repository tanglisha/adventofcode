#lang racket
(require racket/file)

(define (split nums)
  (cond
    [(= nums 0) '()]
    [else
     (append (split (quotient nums 10))
              (list (modulo nums 10)))]))

(define (transform input)
  (cond
    [(list? input) input]
    [else (append (split (string->number input))
                         (list (car (split (string->number input)))))]))

(define (captcha s)
  (let ([l (transform s)])
    (cond
      [(> 2 (length l)) 0]
      [(equal? (car l) (car (cdr l))) (+ (car l) (captcha (cdr l)))]
      [else (+ 0 (captcha (cdr l)))])))

(define (run-day-1)
  ((write "Day 1 Part 1: ")
  (print (captcha (regexp-replace
            #rx"[\n\"]"
            (file->string
            (path->complete-path
             (string->path "day1data.txt")) #:mode 'text)
            "")))))

(require rackunit)
(check-equal? (split 123) '(1 2 3))
(check-equal? (transform "123") '(1 2 3 1))

(check-equal? (captcha "1111") 4 "All matches")
(check-equal? (captcha "1122") 3 "Each matches once")
(check-equal? (captcha "1234") 0 "No matches")
(check-equal? (captcha "91212129") 9 "Only first and last match")


