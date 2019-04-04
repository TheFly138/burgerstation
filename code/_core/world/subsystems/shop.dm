var/global/list/shops = list()


/subsystem/shop/
	name = "Shop Subsystem"
	desc = "Controls shops."
	tick_rate = SECONDS_TO_TICKS(1)
	priority = SS_ORDER_SHOP

	var/countdown = SHOP_RESTOCK_COUNTDOWN


/subsystem/shop/Initialize()

	for(var/obj/structure/interactive/shop_holder/S in world)
		var/area/A = get_area(S)
		if(shops[A.id])
			shops[A.id] += S
		else
			shops[A.id] = list(S)

	restock()

/subsystem/shop/on_life()

	countdown -= 1

	if(countdown <= 0)
		restock()
		countdown = initial(countdown)


	return TRUE


/subsystem/shop/proc/restock()
	for(var/k in shops)
		for(var/obj/structure/interactive/shop_holder/S in shops[k])
			S.restock()