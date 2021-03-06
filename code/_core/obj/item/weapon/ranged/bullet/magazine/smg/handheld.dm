/obj/item/weapon/ranged/bullet/magazine/smg/handheld
	name = "\improper 9mm SMP"
	icon = 'icons/obj/items/weapons/ranged/smg/9mm.dmi'
	icon_state = "inventory"

	shoot_delay = 2

	automatic = TRUE

	shoot_sounds = list('sounds/weapons/silenced/fire.ogg')

	can_wield = FALSE

	view_punch = 4

	slowdown_mul_held = HELD_SLOWDOWN_SMG

	size = SIZE_2
	weight = WEIGHT_2

	heat_per_shot = 0.03
	heat_max = 0.3

	bullet_length_min = 16
	bullet_length_best = 19
	bullet_length_max = 20

	bullet_diameter_min = 8.5
	bullet_diameter_best = 9
	bullet_diameter_max = 9.5

	value = 120

/obj/item/weapon/ranged/bullet/magazine/smg/handheld/get_static_spread() //Base spread
	return 0.04

/obj/item/weapon/ranged/bullet/magazine/smg/handheld/get_skill_spread(var/mob/living/L) //Base spread
	return 0.05 - (0.05 * L.get_skill_power(SKILL_RANGED))