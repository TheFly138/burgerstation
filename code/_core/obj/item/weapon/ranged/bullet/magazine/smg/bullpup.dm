/obj/item/weapon/ranged/bullet/magazine/smg/bullpup
	name = ".45 C-20r submachine gun"
	icon = 'icons/obj/items/weapons/ranged/smg/45.dmi'
	icon_state = "inventory"

	projectile_speed = 20
	shoot_delay = 1.5

	automatic = TRUE

	shoot_sounds = list('sounds/weapons/45/shoot_silenced.ogg')

	can_wield = FALSE

	override_icon_state = TRUE

	view_punch = 6

	slowdown_mul_held = HELD_SLOWDOWN_SMG

	size = SIZE_3
	weight = WEIGHT_3

	heat_per_shot = 0.01
	heat_max = 0.1

	bullet_length_min = 20
	bullet_length_best = 23
	bullet_length_max = 24

	bullet_diameter_min = 11
	bullet_diameter_best = 11.43
	bullet_diameter_max = 12

	value = 150

/obj/item/weapon/ranged/bullet/magazine/smg/bullpup/update_icon()
	if(stored_magazine)
		var/obj/item/magazine/M = stored_magazine
		icon_state = "[initial(icon_state)]_[round(length(M.stored_bullets),4)]"
	else
		icon_state = initial(icon_state)

	..()

/obj/item/weapon/ranged/bullet/magazine/smg/bullpup/get_static_spread() //Base spread
	return 0.03

/obj/item/weapon/ranged/bullet/magazine/smg/bullpup/get_skill_spread(var/mob/living/L) //Base spread
	return 0.02 - (0.02 * L.get_skill_power(SKILL_RANGED))