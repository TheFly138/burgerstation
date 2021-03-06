/obj/item/proc/prune_inventory()

	var/list/obj/hud/inventory/dynamic/bad_inventories = list()
	var/good_inventory_count = 0

	for(var/obj/hud/inventory/dynamic/I in inventories)

		if(!length(I.held_objects) && !length(I.worn_objects))
			bad_inventories += I
		else
			good_inventory_count += 1


	var/delete_until = good_inventory_count < 8 ? good_inventory_count : CEILING(good_inventory_count,8)

	for(var/obj/hud/inventory/dynamic/I in bad_inventories)
		if(I.slot_num > delete_until)
			inventories -= I
			qdel(I)

	return TRUE


/obj/item/proc/update_inventory() //When this object's inventory was updated.
	return TRUE

/obj/item/on_spawn()
	if(length(inventories))
		fill_inventory()
	return ..()

/obj/item/proc/fill_inventory()

	for(var/obj/item/I in contents)
		INITIALIZE(I)
		SPAWN(I)
		add_to_inventory(null,I,FALSE,TRUE)

	return TRUE