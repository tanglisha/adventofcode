#lang racket

(require racket/file)

(define (split-line l)
  (string-split l "\t"))

(define (stringlist->numlist s)
  (cond
    [(> 1 (length s)) '()]
    [else (append (list
                   (string->number (car s)))
                  (stringlist->numlist (cdr s)))]))

(define (file-to-list lines)
  (cond
    [(> 1 (length lines)) '()]
    [else (append
           (list (stringlist->numlist (split-line (car lines))))
           (file-to-list (cdr lines)))]))

(define (read-data-file file-name)
  (file-to-list 
    (file->lines
    (path->complete-path
    (string->path file-name))
    #:mode 'text)))

(define (checksum-line l)
  (- (apply max l) (apply min l)))

(define (div-even-divisors num l)
  (if (equal? l '()) 0
      (let ([sec (car l)]
            [big (max num (car l))]
            [small (min num (car l))])
        (cond
          [(equal? 0 (modulo big small)) (quotient big small)]
          [else (div-even-divisors num (cdr l))]))))

(define (checksum-line-evens l)
  (if (equal? l '()) 0
  (let ([sum (div-even-divisors (car l) (cdr l))])
    (cond
      [(< 0 sum) sum]
      [else (checksum-line-evens (cdr l))]))))

(define (checksum l)
  (cond
    [(> 1 (length l)) 0]
    [else (+ (checksum-line (car l))
            (checksum (cdr l)))]))

(define (checksum-even l)
  (cond
    [(> 1 (length l)) 0]
    [else (+ (checksum-line-evens (car l))
             (checksum-even (cdr l)))]))

(provide run-day-2)
(define (run-day-2)
  (void
   (write "Day 2 Part 1:")
   (print 
    (checksum (read-data-file "day2data.txt")))
   (write "      Part 2:")
   (print (checksum-even (read-data-file "day2data.txt")))))

(require rackunit)
(check-equal? (file-to-list '("1\t2\t3" "4\t5\t6" "7\t8\t9")) '((1 2 3) (4 5 6) (7 8 9)))
(check-equal? (div-even-divisors 2 '(1 3 4)) 2 "Big number comes second")
(check-equal? (div-even-divisors 8 '(5 2 9)) 4 "Big number comes first")
(check-equal? (checksum-line '(1 2 3 4)) 3)
(check-equal? (checksum-line-evens '(5 9 2 8)) 4)
(check-equal? (checksum-line-evens '(9 4 7 3)) 3)
(check-equal? (checksum-line-evens '(3 8 6 5)) 2)
(check-equal? (stringlist->numlist '("123" "456" "78")) '(123 456 78))
(check-equal? (split-line "13\t123\t45") '("13" "123" "45"))
(check-equal? (checksum (list '(5 1 9 5) '(7 5 3) '(2 4 6 8))) 18)
(check-equal? (checksum-even (list '(5 9 2 8) '(9 4 7 3) '(3 8 6 5))) 9)
