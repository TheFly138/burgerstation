/obj/item/weapon/ranged/bullet/magazine/rifle/tungsten
	name = "\improper AP Tungsten Carbine"
	icon = 'icons/obj/items/weapons/ranged/smg/tungsten.dmi'
	icon_state = "inventory"
	shoot_delay = 2
	view_punch = 4
	shoot_sounds = list('sounds/weapons/223/shoot.ogg')

	heat_per_shot = 0.005
	heat_max = 0.05

	bullet_length_min = 15
	bullet_length_best = 20
	bullet_length_max = 25

	bullet_diameter_min = 4
	bullet_diameter_best = 5
	bullet_diameter_max = 6

	automatic = FALSE

	override_icon_state = TRUE

	size = SIZE_3
	weight = WEIGHT_3

	value = 100

/obj/item/weapon/ranged/bullet/magazine/rifle/tungsten/update_icon()

	icon_state = initial(icon_state)

	if(stored_magazine)
		icon_state = "[icon_state]_[CEILING((length(stored_magazine.stored_bullets)/stored_magazine.bullet_count_max)*5, 1)]"

	return ..()

/obj/item/weapon/ranged/bullet/magazine/rifle/tungsten/get_static_spread() //Base spread
	return 0.02

/obj/item/weapon/ranged/bullet/magazine/rifle/tungsten/get_skill_spread(var/mob/living/L) //Base spread
	return 0.05 - (0.05 * L.get_skill_power(SKILL_RANGED))

/obj/item/weapon/ranged/bullet/magazine/rifle/tungsten/get_cock_sound(var/direction="both")
	return 'sounds/weapons/gun/smg/smg_rack.ogg'