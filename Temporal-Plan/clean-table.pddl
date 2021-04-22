(define (domain cleaning)

    (:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions :disjunctive-preconditions)
    (:types
        location gripper customer drink table - object
        table bar - location
        left right - gripper
        warm cold - drink
        big small - table
    )

    (:predicates
        (at-robby ?location - location)
        (conn ?from ?to - location)
        (carrying-tray)
        (carrying ?drink - drink)
        (gripper-free ?g - gripper)
        (drink-at ?drink - drink ?location - location)
        (loading-tray)
        (tray-at-bar)
        (customer-at ?customer ?table)
        (drink-order ?customer ?drink)
        (preparing)
        (need-clean ?table - table)
        (cleaning)
        (table-clean ?table - table)
    )

    (:functions
        (conn-length ?from ?to - location)
        (fast-speed)
        (slow-speed)
        (on-tray)
        (drink-ready)
        (cold-prep)
        (warm-prep)
    )

    (:durative-action move-fast
        :parameters (?from ?to - location)
        :duration (= ?duration (/ (conn-length ?from ?to) (fast-speed)))
        :condition (and
            (at start (and (at-robby ?from) (not (cleaning)) (or (not (carrying-tray)) (= (on-tray) 0))))
            (over all (conn ?from ?to))
        )

        :effect (and
            (at start (not (at-robby ?from)))
            (at end (and (at-robby ?to) (not (at-robby ?from))))
        )
    )

    (:durative-action move-slow
        :parameters (?from ?to - location)
        :duration (= ?duration (/ (conn-length ?from ?to) (slow-speed)))
        :condition (and
            (at start (and (at-robby ?from) (carrying-tray) (> (on-tray) 0)))
            (over all (and (conn ?from ?to)))
        )

        :effect (and
            (at start (and (not (at-robby ?from)) (carrying-tray)))
            (at end (and (at-robby ?to) (not (at-robby ?from)) (carrying-tray)))
        )
    )
    (:durative-action clean-small-table
        :parameters (?small - small)
        :duration (= ?duration 2)
        :condition (and
            (at start (and
                    (at-robby ?small) (need-clean ?small) (not (cleaning))
                ))
            (over all (and
                    (at-robby ?small)
                ))
        )
        :effect (and
            (at start (and
                    (not (need-clean ?small)) (cleaning)
                ))
            (at end (and
                    (not (cleaning))
                    (not (need-clean ?small))
                    (table-clean ?small)
                ))
        )
    )

    (:durative-action clean-big-table
        :parameters (?big - big)
        :duration (= ?duration 4)
        :condition (and
            (at start (and
                    (at-robby ?big) (need-clean ?big) (not (cleaning))
                ))
            (over all (and
                    (at-robby ?big)
                ))
        )
        :effect (and
            (at start (and
                    (not (need-clean ?big)) (cleaning)
                    ))
                (at end (and
                        (not (cleaning))
                        (not (need-clean ?big))
                        (table-clean ?big)
                    ))
            
        )
    )
)