/obj/structure/smooth/window/directional
	name = "window"
	icon = 'icons/obj/structure/smooth/window/single_new.dmi'
	icon_state = "single"

	corner_category = null
	corner_icons = FALSE

	anchored = FALSE

	change_dir_on_move = FALSE

	var/force_corner = FALSE

/obj/structure/smooth/window/directional/anchored
	anchored = TRUE

/obj/structure/smooth/window/directional/Initialize()

	if(dir in DIRECTIONS_INTERCARDINAL)
		force_corner = TRUE
		name = "corner window"

	return ..()

/obj/structure/smooth/window/directional/set_dir(var/desired_dir,var/force = FALSE)

	if(force_corner)
		switch(desired_dir)
			if(NORTH)
				desired_dir = NORTHEAST
			if(EAST)
				desired_dir = SOUTHEAST
			if(SOUTH)
				desired_dir = SOUTHWEST
			if(WEST)
				desired_dir = NORTHWEST
	else
		switch(desired_dir)
			if(NORTHEAST)
				desired_dir = NORTH
			if(SOUTHEAST)
				desired_dir = EAST
			if(SOUTHWEST)
				desired_dir = SOUTH
			if(NORTHWEST)
				desired_dir = WEST

	. = ..(desired_dir,force)

	density_north = FALSE
	density_east = FALSE
	density_south = FALSE
	density_west = FALSE

	if(dir & NORTH)
		density_north = TRUE

	if(dir & EAST)
		density_east = TRUE

	if(dir & SOUTH)
		density_south = TRUE

	if(dir & WEST)
		density_west = TRUE

	return .