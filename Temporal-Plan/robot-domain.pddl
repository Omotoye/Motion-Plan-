(define (domain robot-domain)

    (:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions)
    (:types
        location gripper customer drink table - object
        table bar - location ; the two locations the waiter robot can be at
        left right - gripper
        warm cold - drink
        small big - table
    )

    (:predicates
        (at-robby ?location - location) ; where the waiter robot is at
        (conn ?from ?to - location) ; true, if two locations are connected 
        (carrying-tray)
        (carrying ?drink - drink)
        (gripper-free)
        (drink-at ?drink - drink ?location - location)
        (loading-tray)
        (tray-at-bar)
        (drink-order ?table - table ?drink - drink)
        (preparing) ; true, if the barista robot is preparing drink 
        (need-clean ?table - table)
        (cleaning)
        (table-clean ?table - table)
        (tray-ready)
    )

    (:functions
        (conn-length ?from ?to - location)
        (on-tray) ; the amount of drinks on a tray 
        (drink-ready) ; the amount of drinks that are ready 
        (cold-prep) ; time it takes to prepare cold drink 
        (warm-prep) ; time it takes to prepare warm drink 
        (speed)
    )

    (:durative-action prepare-cold-drink
        :parameters (?cold - cold ?table - table ?bar - bar)
        :duration (= ?duration (cold-prep))
        :condition (and
            (at start (and
                    (drink-order ?table ?cold) (not (preparing))
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
        :parameters (?warm - warm ?table - table ?bar - bar)
        :duration (= ?duration (warm-prep))
        :condition (and
            (at start (and
                    (drink-order ?table ?warm) (not (preparing))
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

    (:action pick-up-drink
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free) (> (drink-ready) 0) (< (drink-ready) 2) (not (loading-tray))
            (not (carrying ?drink)) (tray-at-bar) (< (on-tray) 1)
        )
        :effect (and (not (drink-at ?drink ?bar)) (assign (speed) 2) (not (gripper-free)) (carrying ?drink) (decrease (drink-ready) 1))
    )

    (:action load-tray
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free)
            (> (drink-ready) 1)
            (not (carrying ?drink)) (< (on-tray) 3) (tray-at-bar)
        )
        :effect (and (carrying ?drink) (not (drink-at ?drink ?bar)) (increase (on-tray) 1) (decrease (drink-ready) 1) (loading-tray)
            (gripper-free)
        )
    )

    (:action load-last-drink
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free)
            (> (drink-ready) 0) (loading-tray)
            (not (carrying ?drink)) (< (on-tray) 3) (tray-at-bar)
        )
        :effect (and (carrying ?drink) (not (drink-at ?drink ?bar)) (increase (on-tray) 1) (decrease (drink-ready) 1) (not (loading-tray))
            (tray-ready) (gripper-free)
        )
    )

    (:action pick-up-tray
        :parameters (?bar - bar)
        :precondition (and (not (loading-tray)) (tray-ready) (tray-at-bar) (gripper-free) (at-robby ?bar))
        :effect (and (carrying-tray) (assign (speed) 1) (not (tray-at-bar)) (not (loading-tray)) (not (gripper-free)) (not (tray-ready)))
    )

    (:durative-action move
        :parameters (?from ?to - location)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed)))
        :condition (and
            (at start (and (at-robby ?from)
                ))
            (over all (and (conn ?from ?to)
                ))
        )
        :effect (and
            (at start (not (at-robby ?from)))
            (at end (and (at-robby ?to) (not (at-robby ?from))))
        )
    )

    (:action drop-drink
        :parameters (?drink - drink ?table - table)
        :precondition (and (drink-order ?table ?drink) (at-robby ?table) (carrying ?drink)
            (not (carrying-tray)) (not (gripper-free))
        )
        :effect (and (drink-at ?drink ?table) (not (carrying ?drink))
            (gripper-free)
        )
    )

    (:action drop-tray-drink
        :parameters (?drink - drink ?table - table)
        :precondition (and (carrying ?drink) (at-robby ?table) (drink-order ?table ?drink) (not (tray-at-bar))
            (carrying-tray) (> (on-tray) 0) (not (gripper-free))
        )
        :effect (and (drink-at ?drink ?table) (not (carrying ?drink))
            (decrease (on-tray) 1) (not (gripper-free))
        )
    )

    (:action drop-tray
        :parameters (?bar - bar)
        :precondition (and (carrying-tray) (< (on-tray) 1) (at-robby ?bar) (not (gripper-free)))
        :effect (and (not (carrying-tray)) (tray-at-bar) (assign (speed) 2)
            (gripper-free))
    )

    (:durative-action clean-small-table
        :parameters (?small - small)
        :duration (= ?duration 2)
        :condition (and
            (at start (and
                    (at-robby ?small) (need-clean ?small) (not (cleaning)) (gripper-free) (not (tray-ready)) (not (loading-tray)) (not (carrying-tray))
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
                    (at-robby ?big) (need-clean ?big) (not (cleaning)) (gripper-free) (not (tray-ready)) (not (loading-tray))(not (carrying-tray))
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