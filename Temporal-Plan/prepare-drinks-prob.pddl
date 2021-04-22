(define (problem prepare-drinks-prob)
    (:domain prepare-drinks)
    (:objects
        table1 table2 table3 table4 - table
        bar - bar
        drink1 drink2 drink3 - cold
        drink4 - warm
        left - left
        right - right
        customer1 customer2 customer3 - customer
    )

    (:init
        (drink-order customer1 drink1)
        (drink-order customer3 drink3)
        (drink-order customer2 drink4)
        (drink-order customer2 drink2)
        (= (cold-prep) 3)
        (= (warm-prep) 5)
        (= (drink-ready) 0)
    )

    (:goal
        (and
            (drink-at drink1 bar)
            (drink-at drink2 bar)
            (drink-at drink3 bar)
            (drink-at drink4 bar)
            ;(= (drink-ready) 4)
        )
    )

)