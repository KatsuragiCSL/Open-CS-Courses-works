(define (caar x) (car (car x)))
(define (cadr x) (car (cdr x)))
(define (cdar x) (cdr (car x)))
(define (cddr x) (cdr (cdr x)))

; Some utility functions that you may find useful to implement.

(define (cons-all first rests)
      (define (cons-all-hlp l)
          (append (list first) l)
      )
      (map cons-all-hlp rests)
)

(define (zip pairs)
    ; zip ((x1 y1) (x2 y2) (x3 y3)) = (append-each (zip ((x1 y1) (x2 y2))) (x3 y3))
    (define (zip-hlp p first-sofar last-sofar)
        (if (null? p) (list first-sofar last-sofar)
            (zip-hlp (cdr p) (append first-sofar (list (caar p))) (append last-sofar (list (car (cdar p)))))
        )
    )
    (zip-hlp pairs nil nil)
)

;; Problem 16
;; Returns a list of two-element lists
(define (enumerate s)
  ; BEGIN PROBLEM 16
  (define (enum-hlp s i lst-sofar)
      (if (null? s) lst-sofar
        (enum-hlp (cdr s) (+ i 1) (append lst-sofar (list (list i (car s)))))
      )
  )
  (enum-hlp s 0 nil)
)
  ; END PROBLEM 16

;; Problem 17
;; List all ways to make change for TOTAL with DENOMS
(define (list-change total denoms)
  ; BEGIN PROBLEM 17
  (if (null? denoms) nil
    (if (= total 0) (list nil)
        (if (>= total (car denoms))
            (append
                (cons-all (car denoms) (list-change (- total (car denoms)) denoms))
                (list-change total (cdr denoms))
            )
            (list-change total (cdr denoms))
        )
    )
  )
)

  ; END PROBLEM 17

;; Problem 18
;; Returns a function that checks if an expression is the special form FORM
(define (check-special form)
  (lambda (expr) (equal? form (car expr))))

(define lambda? (check-special 'lambda))
(define define? (check-special 'define))
(define quoted? (check-special 'quote))
(define let?    (check-special 'let))

;; Converts all let special forms in EXPR into equivalent forms using lambda
(define (let-to-lambda expr)
  (cond ((atom? expr)
         ; BEGIN PROBLEM 18
         expr
         ; END PROBLEM 18
         )
        ((quoted? expr)
         ; BEGIN PROBLEM 18
         expr
         ; END PROBLEM 18
         )
        ((or (lambda? expr)
             (define? expr))
         (let ((form   (car expr))
               (params (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 18
           (cons form (cons params (map let-to-lambda body)))
           ; END PROBLEM 18
           ))
        ((let? expr)
         (let ((values (cadr expr))
               (body   (cddr expr)))
           ; BEGIN PROBLEM 18
	   (define formals-values (zip values))
           (append (cons (cons 'lambda (cons (car formals-values) (map let-to-lambda body))) nil) (map let-to-lambda (cadr formals-values)))
           ; END PROBLEM 18
           ))
        (else
         ; BEGIN PROBLEM 18
         (cons (car expr) (map let-to-lambda (cdr expr)))
         ; END PROBLEM 18
         )))
