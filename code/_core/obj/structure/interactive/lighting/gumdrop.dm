/obj/structure/interactive/lighting/gumdrop
	name = "gumpdrop"
	icon = 'icons/obj/structure/flora/gumdrops.dmi'
	icon_state = "gumdrop"
	layer = LAYER_GROUND_SCENERY

	alpha = 200

	light_power = 0.5
	light_range = 4
	light_color = "#FFFFFF"

/obj/structure/interactive/lighting/gumdrop/New()
	..()

	switch(rand(1,3))
		if(1)
			color = rgb(255,pick(0,255),pick(0,255))
		if(2)
			color = rgb(pick(0,255),255,pick(0,255))
		if(3)
			color = rgb(pick(0,255),pick(0,255),255)

	light_color = color