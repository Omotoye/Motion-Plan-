;Header and description

(define (domain prepare-drinks)

    ;remove requirements that are not needed
    (:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions :disjunctive-preconditions)
    (:types
        location gripper customer drink table - object
        table bar - location
        left right - gripper
        warm cold - drink
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

    (:durative-action prepare-cold-drink
        :parameters (?cold - cold ?customer - customer ?bar - bar)
        :duration (= ?duration (cold-prep))
        :condition (and
            (at start (and
                    (drink-order ?customer ?cold) (not (preparing))
                ))

        )
        :effect (and
            (at start (and
                    (preparing)
                ))
            (at end (and
                    (not (preparing))
                    (increase (drink-ready) 1)
                    (drink-at ?cold ?bar)
                ))
        )
    )

    (:durative-action prepare-warm-drink
        :parameters (?warm - warm ?customer - customer ?bar - bar)
        :duration (= ?duration (warm-prep))
        :condition (and
            (at start (and
                    (drink-order ?customer ?warm) (not (preparing))
                ))
        )
        :effect (and
            (at start (preparing))
            (at end (and
                    (not (preparing))
                    (increase (drink-ready) 1)
                    (drink-at ?warm ?bar)
                ))
        )
    )

)