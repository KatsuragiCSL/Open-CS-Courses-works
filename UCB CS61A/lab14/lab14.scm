(define (split-at lst n)
    (define (split-hlp head tail n)
        (if (null? tail) (cons head tail)
            (if (= n 0) (cons head tail)
                (split-hlp (append head (list(car tail))) (cdr tail) (- n 1))
            )
        )
    )

    (split-hlp nil lst n)
)


(define-macro (switch expr cases)
	 (cons 'cond 
	   (map (lambda (case) (cons `(eq?, expr ',(car case)) (cdr case)))
    			cases))
)
