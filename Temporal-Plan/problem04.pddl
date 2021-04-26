(define (problem problem04)
    (:domain robot-domain)
    (:objects
        table1 table2 table4 - small
        table3 - big
        bar - bar
        warm1 warm2 warm3 warm4 - warm
        cold1 cold2 cold3 cold4 - cold
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

        (gripper-free)

        (tray-at-bar)

        (drink-order table3 warm1)
        (drink-order table3 warm2)
        (drink-order table3 warm3)
        (drink-order table3 warm4)
        (drink-order table1 cold1)
        (drink-order table1 cold2)
        (drink-order table4 cold3)
        (drink-order table4 cold4)

        (need-clean table2)

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

        (= (on-tray) 0)
        (= (drink-ready) 8)
        (= (cold-prep) 3)
        (= (warm-prep) 5)
        (= (speed) 2)
    )

    (:goal
        (and
            (drink-at warm1 table3)
            (drink-at warm2 table3)
            (drink-at warm3 table3)
            (drink-at warm4 table3)
            (drink-at cold1 table1)
            (drink-at cold2 table1)
            (drink-at cold3 table4)
            (drink-at cold4 table4)

            ;(table-clean table2)
        )
    )

    (:metric minimize
        (total-time)
    )
)