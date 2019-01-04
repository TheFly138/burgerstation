/mob/living/advanced
	var/datum/species/mob_species = /datum/species/human/
	var/datum/outfit/mob_outfit = /datum/outfit/assistant/

	var/list/obj/item/organ/organs
	var/list/obj/item/organ/labeled_organs

	//var/list/obj/item/clothing/clothing

	icon = 'icons/invisible.dmi'
	icon_state = "0"

/mob/living/advanced/New()
	organs = list()
	inventory = list()
	labeled_organs = list()
	if(mob_outfit)
		mob_outfit = new mob_outfit
	if(mob_species)
		mob_species = new mob_species
	..()

/mob/living/advanced/proc/add_species_organs()
	for(var/key in mob_species.spawning_organs)
		add_organ(mob_species.spawning_organs[key])

/mob/living/advanced/proc/add_organ(var/obj/item/organ/O)
	O = new O
	organs += O
	if(O.id)
		labeled_organs[O.id] = O
	if(O.inventory)
		O.inventory.update_owner(src)

/mob/living/advanced/initialize_attributes()
	for(var/v in all_attributes)
		var/experience/attribute/A = new v(src)
		A.experience = A.level_to_xp(mob_species.attribute_defaults[A.id])
		attributes[A.id] = A

/mob/living/advanced/initialize_skills()
	for(var/v in all_skills)
		var/experience/skill/S = new v(src)
		S.experience = S.level_to_xp(mob_species.skill_defaults[S.id])
		skills[S.id] = S

/mob/living/advanced/Initialize()
	add_species_organs()
	add_clothes(mob_outfit)
	update_icon()
	. = ..()

/mob/living/advanced/proc/add_clothes(var/datum/outfit/spawning_outfit)
	if(!spawning_outfit)
		return FALSE

	for(var/key in spawning_outfit.spawning_clothes)
		var/obj/item/clothing/C = new key(get_turf(src))
		add_worn_item(C)

	return TRUE
/mob/living/advanced/proc/add_worn_item(var/obj/item/clothing/C)
	for(var/obj/inventory/I in inventory)
		if(I.add_worn_object(C))
			update_icon()
			return TRUE

/mob/living/advanced/proc/remove_worn_item(var/obj/item/clothing/C)
	for(var/obj/inventory/I in inventory)
		if(I.remove_object(C))
			return TRUE

	return FALSE

/mob/living/advanced/update_icon()

	for(var/O in overlays)
		O = null
		del(O)
	overlays = list()

	for(var/obj/item/organ/O in organs)
		O.update_icon()
		var/obj/overlay/spawned_overlay = new /obj/overlay
		spawned_overlay.layer = O.worn_layer
		spawned_overlay.icon = O.icon
		spawned_overlay.icon_state = O.icon_state
		overlays += spawned_overlay

	for(var/obj/inventory/I in inventory)
		//I.update_owner(src.client)
		for(var/obj/item/clothing/C in I.worn_objects)
			C.update_icon()
			var/obj/overlay/spawned_overlay = new /obj/overlay
			spawned_overlay.layer = C.worn_layer
			spawned_overlay.icon = C.icon
			spawned_overlay.icon_state = C.icon_state_worn
			overlays += spawned_overlay
		for(var/obj/item/I2 in I.held_objects)
			I2.update_icon()
			var/obj/overlay/spawned_overlay = new /obj/overlay
			spawned_overlay.layer = LAYER_MOB_HELD
			spawned_overlay.icon = I2.icon
			if(I.item_slot == SLOT_HAND_LEFT)
				spawned_overlay.icon_state = I2.icon_state_held_left
			else
				spawned_overlay.icon_state = I2.icon_state_held_right

			overlays += spawned_overlay

	. = ..()