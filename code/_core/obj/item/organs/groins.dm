/obj/item/organ/groin
	name = "groin"
	id = BODY_GROIN
	desc = "An organ."
	icon_state = BODY_GROIN_MALE
	worn_layer = LAYER_MOB_GROIN
	break_threshold = 50
	//health_max = 75
	inventories = list(
		/obj/hud/inventory/organs/groin,
		/obj/hud/inventory/organs/groin_o,
		/obj/hud/inventory/organs/groin/pocket/right,
		/obj/hud/inventory/organs/groin/pocket/left

	)

	attach_flag = BODY_TORSO

	enable_wounds = TRUE

	hud_id = "body_groin"

	can_be_targeted = TRUE

	target_bounds_x_min = 12
	target_bounds_x_max = 20

	target_bounds_y_min = 9
	target_bounds_y_max = 13

	health_base = 50

/obj/item/organ/groin/female
	desc = "A groin. Female variant"
	icon_state = BODY_GROIN_FEMALE

//Reptile Feral
/obj/item/organ/groin/reptile
	name = "reptile groin"
	icon = 'icons/mob/living/advanced/species/reptile.dmi'

/obj/item/organ/groin/reptile/female
	icon_state = BODY_GROIN_FEMALE


//Reptile Advanced
/obj/item/organ/groin/reptile_advanced
	name = "reptile groin"
	icon = 'icons/mob/living/advanced/species/reptile_advanced.dmi'

/obj/item/organ/groin/reptile_advanced/female
	icon_state = BODY_GROIN_FEMALE

//Diona
/obj/item/organ/groin/diona
	name = "diona groin"
	icon = 'icons/mob/living/advanced/species/diona.dmi'
	icon_state = BODY_GROIN

	enable_glow = TRUE
	enable_detail = TRUE

//cyborg
/obj/item/organ/groin/cyborg
	name = "cyborg groin"
	icon = 'icons/mob/living/advanced/species/cyborg.dmi'


//Beefman
/obj/item/organ/groin/beefman
	name = "beef groin"
	icon = 'icons/mob/living/advanced/species/beefman.dmi'