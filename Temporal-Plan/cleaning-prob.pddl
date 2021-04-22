(define (problem cleaning-prob)
    (:domain cleaning)
    (:objects
        table1 table2 table3 - big
        table4 - small
        bar - bar
        drink1 drink2 drink3 - cold
        drink4 drink6 drink5 - warm
        left - left
        right - right
        customer1 customer2 customer3 - customer
    )

    (:init
        (at-robby bar)
        (conn bar table1)
        (conn table1 bar)
        (conn bar table2)
        (conn table2 bar)
        (conn table1 table2)
        (conn table2 table1)
        (conn table1 table3)
        (conn table3 table1)
        (conn table1 table4)
        (conn table4 table1)
        (conn table2 table4)
        (conn table4 table2)
        (conn table2 table3)
        (conn table3 table2)
        (conn table3 table4)
        (conn table4 table3)

        (gripper-free left)
        (gripper-free right)

        ;(drink-at drink1 bar)
        ;(drink-at drink2 bar)
        ;(drink-at drink3 bar)
        ;(drink-at drink4 bar)
        (tray-at-bar)
        (customer-at customer1 table4)
        (drink-order customer1 drink1)
        (customer-at customer2 table4)
        (customer-at customer3 table3)
        (drink-order customer3 drink3)
        (drink-order customer3 drink5)
        (drink-order customer1 drink6)
        (drink-order customer2 drink4)
        (drink-order customer2 drink2)

        (= (conn-length bar table1) 2)
        (= (conn-length table1 bar) 2)
        (= (conn-length bar table2) 2)
        (= (conn-length table2 bar) 2)
        (= (conn-length table1 table2) 1)
        (= (conn-length table2 table1) 1)
        (= (conn-length table1 table3) 1)
        (= (conn-length table3 table1) 1)
        (= (conn-length table1 table4) 1)
        (= (conn-length table4 table1) 1)
        (= (conn-length table2 table4) 1)
        (= (conn-length table4 table2) 1)
        (= (conn-length table2 table3) 1)
        (= (conn-length table3 table2) 1)
        (= (conn-length table3 table4) 1)
        (= (conn-length table4 table3) 1)

        (= (fast-speed) 2)
        (= (slow-speed) 1)
        (= (on-tray) 0)
        (= (drink-ready) 6)
        (= (cold-prep) 3)
        (= (warm-prep) 5)

        (need-clean table3)
        (need-clean table4)

    )

    (:goal
        (and
            (table-clean table3)
            (table-clean table4)
        )
    )

    (:metric minimize
        (total-time)
    )
)