obj/structure/interactive/barricade
	name = "metal barricade"
	desc_extended = "Has a 60% chance to block most types of projectiles when a bullet passes it from the outside."
	icon = 'icons/obj/structure/barricade.dmi'
	icon_state = "metal"

	plane = PLANE_MOB
	collision_flags = FLAG_COLLISION_REAL
	collision_bullet_flags = FLAG_COLLISION_BULLET_INORGANIC

	density_north = FALSE
	density_south = FALSE
	density_east  = FALSE
	density_west  = FALSE

	bullet_block_chance = 80

obj/structure/interactive/barricade/New(var/desired_loc)
	. = ..()
	update_sprite()
	return .


obj/structure/interactive/barricade/update_sprite()

	. = ..()

	if(dir == NORTH)
		pixel_y = -10
		density_north = TRUE
	else if(dir == EAST)
		pixel_x = 0
		pixel_y = -2
		density_east = TRUE
	else if(dir == SOUTH)
		pixel_x = 0
		pixel_y = 0
		density_south = TRUE
	else if(dir == WEST)
		pixel_x = 0
		pixel_y = -2
		density_west = TRUE

	return .

obj/structure/interactive/barricade/update_overlays()

	. = ..()

	var/image/above = new/image(icon,"[icon_state]_above")
	above.layer = LAYER_MOB_ABOVE

	var/image/below = new/image(icon,"[icon_state]_below")
	below.layer = LAYER_MOB_BELOW

	icon = ICON_INVISIBLE
	add_overlay(below)
	add_overlay(above)

	return .
