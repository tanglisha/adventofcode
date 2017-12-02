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

(define (transform2 input)
  (cond
    [(list? input) input]
    [else (split (string->number input))]))


(define (middle-item l)
  (list-ref l (quotient (length l) 2)))

(define (captcha s)
  (let ([l (transform s)])
    (cond
      [(> 2 (length l)) 0]
      [(equal? (car l) (car (cdr l))) (+ (car l) (captcha (cdr l)))]
      [else (+ 0 (captcha (cdr l)))])))

(define (captcha2 s)
  (let ([l (transform2 s)]
        [new-tail (* -1 (car (transform2 s)))])
    (cond
      [(< (car l) 0) 0]
      [(equal? (car l) (abs (middle-item l))) (+ (car l)
                                           (captcha2 (cdr (append l `(,new-tail)))))]
      [else (+ 0 (captcha2 (cdr (append l `(,new-tail)))))])))

(define (read-data-file file-name)
  (regexp-replace
   #rx"[\n\"]"
   (file->string
    (path->complete-path
     (string->path "day1data.txt")) #:mode 'text)
   ""))

(provide run-day-1)
(define (run-day-1)
  (void
   (write "Day 1 Part 1: ")
  (print (captcha (read-data-file "day1data.txt")))
   (write "      Part 2: ")
  (print (captcha2 (read-data-file "day1data.txt")))))

(require rackunit)
(check-equal? (split 123) '(1 2 3))
(check-equal? (transform "123") '(1 2 3 1))
(check-equal? (middle-item '(1 2 3)) 2)

(check-equal? (captcha "1111") 4 "All matches")
(check-equal? (captcha "1122") 3 "Each matches once")
(check-equal? (captcha "1234") 0 "No matches")
(check-equal? (captcha "91212129") 9 "Only first and last match")

(check-equal? (captcha2 "1212") 6 "All matches")
(check-equal? (captcha2 "1221") 0 "No matches")
(check-equal? (captcha2 "123123") 12 "All matches")
(check-equal? (captcha2 "12131415") 4 "Only some matches")
