(define (domain warehouse)
		(:requirements :typing)
		(:types robot pallette - bigobject
        	location shipment order saleitem)

  		(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
)

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   (:action robotMove
       :parameters (?r - robot ?l - location ?lo - location)
       :precondition (and (free ?r) (connected ?l ?lo) (at ?r ?l) (no-robot ?lo))
       :effect (and (at ?r ?lo) (not (no-robot ?lo)) (no-robot ?l))
   )

   (:action robotMoveWithPallette
       :parameters (?r - robot ?l - location ?lo - location ?p - pallette)
       :precondition (and  (connected ?l ?lo) (at ?r ?l) (at ?p ?l) (no-pallette ?lo) (no-robot ?lo))
       :effect (and (not (free ?r)) (no-pallette ?l) (no-robot ?l) (at ?r ?lo) (at ?p ?lo) (not (no-robot ?lo)) (not (no-pallette ?lo)))
   )

   (:action moveItemFromPalletteToShipment
       :parameters (?lo - location ?o - order ?s - shipment ?p - pallette ?si - saleitem)
       :precondition (and (ships ?s ?o) (at ?p ?lo) (orders ?o ?si) (not (includes ?s ?si)) (available ?lo) (packing-location ?lo) (contains ?p ?si))
       :effect (and (includes ?s ?si) (not (contains ?p ?si)) (not (orders ?o ?si)))
   )

   (:action completeShipment
       :parameters (?s - shipment ?o - order ?l - location)
       :precondition (and (ships ?s ?o) (started ?s) (packing-at ?s ?l) (not (available ?l)))
       :effect (and (complete ?s) (not (packing-at ?s ?l)) (not (started ?s)) (unstarted ?s) (available ?l))
   )
)