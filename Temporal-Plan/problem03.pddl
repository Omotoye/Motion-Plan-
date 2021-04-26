(define (problem problem03)
    (:domain robot-domain)
    (:objects
        table1 table2 table4 - small
        table3 - big
        bar - bar
        warm1 warm2 warm3 warm4 - warm
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

        (drink-order table1 warm1)
        (drink-order table1 warm2)
        (drink-order table4 warm3)
        (drink-order table4 warm4)

        (need-clean table3)

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
        (= (drink-ready) 4)
        (= (cold-prep) 3)
        (= (warm-prep) 5)
        (= (speed) 2)
    )

    (:goal
        (and
            (drink-at warm1 table1)
            (drink-at warm2 table1)
            (drink-at warm3 table4)
            (drink-at warm4 table4)

            (table-clean table3)
        )
    )

    (:metric minimize
        (total-time)
    )
)