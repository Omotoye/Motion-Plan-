# PDDL 2.1 Model Explanation:

The domain was modeled with Temporal Planning because of its relative ease of representing the model. In this case actions defined to represent the problem are classified into two groups, **durative-actions** _(actions that have a duration)_ and **instantaneous actions.**

### Durative Actions

1. Prepare-drinks
1. Move
1. Clean-table

### Instantaneous actions

1. Pick-up-drink
1. Load-tray
1. Load-last-tray
1. Pick-up-tray
1. Drop-drink
1. Drop-tray-drink
1. Drop-tray

## Drink Preparation

---

The preparation of the drinks is handled by a single durative-action; prepare-drink. This action is autonomous from the rest of the actions in the model, it is initiated by the predicate **_(drink-order ?table ?drink)_**. If a drink is ordered by a customer the barista robot prepares the drink ordered. Each drink has its duration for the preparation which depends on the type of drink it is (cold or warm). If it’s cold the preparation duration is 3 time unit and if it is warm the preparation duration is 5 time unit. The duration of the drink is initialized in the problem file with the function **_(prep-time ?drink)_**. The preparation of a drink has to be over before the preparation of another drink is started, the boolean predicate **_(preparing)_** helps to make this happen. The barista robot sets the predicate **_(preparing)_** to true after starting the drink preparation which makes it impossible to start the preparation of another drink. And when the preparation is done the barista robot drops the drink at the bar and increases the value of drinks that are ready.

```lisp
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
```

## Waiter Movement

---

The modeling of the movement is inspired by an rover movement example I found on a [GitHub page](https://github.com/yarox/pddl-examples.git). **_(conn-length ?from ?to)_** represents the distance between the location from and to, this distance is then used to calculate the time it'll take the waiter robot to move that distance by dividing the distance by the speed (**2 meter / time unit when using the tray, 1 meter / time unit when not using the tray**) of the robot. The robot can only be in one of two types of location, the bar and a table. This is why a bar and table was defined as a subtype of location so the waiter robot can move freely between the bar and the table. The **_(conn ?from ?to)_** predicate is another important predicate that is true if there's a connection between the from and to location. It helps to describe the layout of the restaurant; showing the path of motion that can be taken by the waiter robot. The connection is a one to one connection i.e **(conn bar table1)** and **(conn table1 bar)** meaning the bar is connected to table1 and table1 is connected to the bar. When initializing the connections in the problem file the layout of the restaurant was taken into account, for example; the bar is only connected to the table 1 and table 2, it is not connected to table3 or table4.

![Restaurant Layout](Inkedlayout_LI.jpg "The Restaurant Layout")

```lisp
(:durative-action move
        :parameters (?from ?to - location)
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
```

## Delivering Drinks

---

To deliver a drink to a customer three basic actions has to take place, the waiter robot has to pick up the drink from the bar move to the table where the customer that order the drink is sitted at and drop the drink on that table. To model this actions a number of instantaneous actions were used.

- Pick-up-drink
- Load-tray
- Load-last-tray
- Pick-up-tray
- Drop-drink
- Drop-tray-drink
- Drop-tray

**pick-up-drink**

This action is activated when the number of drinks that are ready is exactly one. For this action the waiter robot picks up the drink with its gripper and set the gripper to not empty, which causes the gripper to be able to pick only one drink at a time. The planning engine used for this domain is LPG, since LPG does not allow equality sign in the procondition, the precondition was modelled in such a way that the precondtion is true when the drinks ready is greater than 0 and less than 2 (which is only true when the drink ready is equal to 1). The precondition **_(not (loading-tray))_** was set because of the use of tray. In the case when the robot is loading the tray with drinks and then reducing the number of drinks that are ready, the **_(loading-tray)_** predicate is set so the waiter robot does'nt pick up a drink while the robot is loading the tray and the drink ready equals 1.

```lisp

    (:action pick-up-drink
        :parameters (?drink - drink ?bar - bar)
        :precondition (and (at-robby ?bar) (drink-at ?drink ?bar) (gripper-free) (> (drink-ready) 0) (< (drink-ready) 2) (not (loading-tray))
            (not (carrying ?drink)) (tray-at-bar) (< (on-tray) 1) (not (carrying-tray))
        )
        :effect (and (not (drink-at ?drink ?bar)) (assign (speed) 2) (not (gripper-free)) (carrying ?drink) (decrease (drink-ready) 1))
    )
```

**load-tray**

The load tray action is activated when the drinks that are ready are greater than 1. The drinks are carried one after the other and p
```lisp
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
```
