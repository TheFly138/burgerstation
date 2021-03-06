var/global/list/area/all_areas_with_hazards = list()
var/global/list/all_hazards = list()

SUBSYSTEM_DEF(hazard)
	name = "Enviromental Hazard Subsystem"
	desc = "Controls hazards, like extreme cold or extreme heat."
	tick_rate = SECONDS_TO_TICKS(10)
	priority = SS_ORDER_IMPORTANT

/subsystem/hazard/Initialize()

	for(var/k in subtypesof(/hazard/))
		var/hazard/H = k
		var/id = initial(H.id)
		if(id)
			H = new k
			all_hazards[id] = H

	log_subsystem(name,"Initialized [length(all_hazards)] hazards.")

	return TRUE

/subsystem/hazard/on_life()

	if(!ENABLE_HAZARDS)
		return FALSE

	spawn()

		for(var/area/A in all_areas_with_hazards)

			if(!A.hazard || !all_hazards[A.hazard])
				continue

			var/hazard/H = all_hazards[A.hazard]
			if(!H)
				continue

			if(A.players_inside)
				for(var/mob/living/advanced/player/P in A.players_inside)
					H.process_player_tick(P)
					sleep(-1)

			sleep(-1)

	return TRUE


