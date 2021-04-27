(define (domain robot-domain)

    (:requirements :typing :fluents :durative-actions :duration-inequalities :negative-preconditions)
    (:types
        table gripper drink bar waiter - object
        waiter1 waiter2 - waiter 
    )

    (:predicates
        (at-robby ?table - table) ; where the waiter robot is at
        (conn ?from ?to - table) ; true, if two tables are connected 
        (carrying-tray)
        (carrying ?drink - drink)
        (gripper-free)
        (drink-at ?drink - drink ?table - table)
        (loading-tray)
        (tray-at-bar)
        (drink-order ?table - table ?drink - drink)
        (need-clean ?table - table)
        (table-clean ?table - table)
        (tray-ready)
        (preparing)
        (waiter-at-bar)
    )

    (:functions
        (conn-length ?from ?to - table)
        (on-tray) ; the amount of drinks on a tray 
        (drink-ready) ; the amount of drinks that are ready 
        (speed)
        (cleaning-time ?table - table)
        (prep-time ?drink)
    )

    (:durative-action prepare-drink
        :parameters (?drink - drink ?table - table ?bar - bar)
        :duration (= ?duration (prep-time ?drink))
        :condition (and
            (at start (drink-order ?table ?drink))
            (at start (not (preparing)))
        )
        :effect (and
            (at start (preparing))
            (at end (not (preparing)))
            (at end (drink-at ?drink ?bar))
            (at end (increase (drink-ready) 1))
        )
    )

    (:action pick-up-drink
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free) (> (drink-ready) 0) (< (drink-ready) 2) (not (loading-tray))
            (not (carrying ?drink)) (tray-at-bar) (< (on-tray) 1) (not (carrying-tray))
        )
        :effect (and (not (drink-at ?drink ?bar)) (assign (speed) 2) (not (gripper-free)) (carrying ?drink) (decrease (drink-ready) 1))
    )

    (:action load-tray
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free)
            (> (drink-ready) 1)
            (not (carrying ?drink)) (< (on-tray) 3) (tray-at-bar) (not (carrying-tray))
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
        :parameters (?from ?to - table)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed)))
        :condition (and
            (at start (at-robby ?from))
            (over all (conn ?from ?to))
        )
        :effect (and
            (at start (not (at-robby ?from)))
            (at end (at-robby ?to))
            (at end (not (at-robby ?from)))
        )
    )

    (:durative-action move-to-bar
        :parameters (?from - table ?to - bar)
        :duration (= ?duration (/ (conn-length ?from ?to) (speed)))
        :condition (and
            (at start (at-robby ?from))
            (at start (not (waiter-at-bar)))
            (over all (conn ?from ?to))
        )
        :effect (and
            (at start (not (at-robby ?from)))
            (at start (waiter-at-bar))
            (at end (not (waiter-at-bar)))
            (at end (at-robby ?to))
            (at end (not (at-robby ?from)))
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

    (:durative-action clean-table
        :parameters (?table - table)
        :duration (= ?duration (cleaning-time ?table))
        :condition (and
            (at start (at-robby ?table))
            (at start (need-clean ?table))
            (at start (not (carrying-tray)))
            (at start (gripper-free))
            (at start (not (tray-ready)))
            (at start (not (loading-tray)))
            (over all (at-robby ?table))
        )
        :effect (and
            (at start (not (need-clean ?table)))
            (at end (not (need-clean ?table)))
            (at end (table-clean ?table))
        )
    )
)