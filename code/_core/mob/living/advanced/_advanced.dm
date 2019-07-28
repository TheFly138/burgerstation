/mob/living/advanced

	name = "lost soul"

	var/species/mob_species = /species/human/

	var/list/obj/item/organ/organs
	var/list/obj/item/organ/labeled_organs

	var/obj/item/automatic_left
	var/obj/item/automatic_right

	/*
	icon = 'icons/invisible.dmi'
	icon_state = "0"
	*/

	var/sex = MALE
	gender = MALE

	var/list/atom/tracked_overlays = list()

	var/draw_inventory = TRUE
	var/list/obj/inventory/inventory //List of inventory items
	var/list/obj/item/worn_objects //List of worn items. For use in an easy read-only list.
	var/obj/inventory/left_hand
	var/obj/inventory/right_hand

	var/is_typing = FALSE

	health_base = 100
	stamina_base = 100
	mana_base = 100

	var/talk_duration = 0
	var/talk_type = 0

	var/automatic_ticks = 0

	var/chargen = FALSE

	var/obj/inventory/active_inventory

	var/health_regen_delay = 0
	var/stamina_regen_delay = 0
	var/mana_regen_delay = 0

	var/obj/vehicle/driving

	var/quick_mode = null

	stun_angle = 90

	random_spawn_dir = FALSE

	has_footsteps = TRUE
	has_footprints = TRUE

/mob/living/advanced/destroy()
	inventory = null
	worn_objects = null
	left_hand = null
	right_hand = null
	active_inventory = null
	driving = null
	return ..()

/mob/living/advanced/proc/do_type(var/type_type)
	talk_type = type_type
	talk_duration = SECONDS_TO_DECISECONDS(6)
	update_icon()

/mob/living/advanced/proc/start_typing()
	is_typing = TRUE
	update_icon()

/mob/living/advanced/proc/end_typing()
	is_typing = FALSE
	update_icon()

/mob/living/advanced/New(loc,desired_client,desired_level_multiplier)
	icon = 'icons/invisible.dmi'
	icon_state = "0"

	organs = list()
	inventory = list()
	worn_objects = list()
	labeled_organs = list()
	if(mob_species)
		mob_species = new mob_species
	..()

/mob/living/advanced/Logout()
	..()
	if(chargen)
		qdel(src)

/mob/living/advanced/on_stunned()

	if(left_hand)
		left_hand.drop_held_objects(src.loc)

	if(right_hand)
		right_hand.drop_held_objects(src.loc)

	return ..()

/mob/living/advanced/proc/drop_all_items(var/exclude_soulbound=FALSE,var/exclude_containers=FALSE)

	var/dropped_objects = list()

	for(var/v in inventory)
		var/obj/inventory/O = v
		if(is_item(O.loc))
			var/obj/item/I = O.loc
			if(I.is_container)
				continue

		dropped_objects += O.drop_all_objects(get_turf(src))

	return dropped_objects

/mob/living/advanced/proc/delete_all_items()
	for(var/v in inventory)
		var/obj/inventory/O = v
		O.delete_all_objects()




/mob/living/advanced/proc/equip_objects_in_list(var/list/clothing_list)
	for(var/obj/item/clothing/C in clothing_list)
		C.quick_equip(src)

mob/living/advanced/Login()
	..()
	if(loc != null)
		restore_buttons()
		restore_inventory()
		restore_health_elements()
		restore_local_machines()

/mob/living/advanced/proc/restore_local_machines()
	for(var/obj/structure/interactive/localmachine/L in local_machines)
		L.update_for_mob(src)

/mob/living/advanced/on_life()

	. = ..()

	if(chargen)
		return .

	if(talk_duration)
		talk_duration = max(0,talk_duration-LIFE_TICK)
		if(talk_duration <= 0)
			talk_type = 0
			update_icon()

	if(!.)
		return .

	var/health_adjust = 0
	var/mana_adjust = 0
	var/stamina_adjust = 0

	if(health_regen_delay <= 0 && health_current < health_max)
		var/heal_amount = health_regeneration*LIFE_TICK*0.1
		if((get_brute_loss() + get_burn_loss())/health_max)
			heal_amount *= 2
		health_adjust = heal_all_organs(heal_amount,heal_amount,0,1)
		if(health_adjust)
			add_skill_xp(SKILL_RECOVERY,health_adjust)

	if(stamina_regen_delay <= 0 && stamina_current < stamina_max)
		var/heal_amount = stamina_regeneration*LIFE_TICK*0.1
		stamina_adjust = adjust_stamina(heal_amount)
		if(stamina_adjust)
			add_skill_xp(SKILL_RECOVERY,stamina_adjust)

	if(mana_regen_delay <= 0 && mana_current < mana_max)
		var/heal_amount = mana_regeneration*LIFE_TICK*0.1
		mana_adjust = adjust_mana(heal_amount)
		if(mana_adjust)
			add_skill_xp(SKILL_RECOVERY,mana_adjust)

	if(health_adjust || stamina_adjust || mana_adjust)
		update_health_element_icons(health_adjust,stamina_adjust,mana_adjust)

	health_regen_delay = max(0,health_regen_delay - LIFE_TICK)
	stamina_regen_delay = max(0,stamina_regen_delay - LIFE_TICK)
	mana_regen_delay = max(0,mana_regen_delay - LIFE_TICK)

	/*
	if(life_ticks >= 10*4)
		for(var/obj/item/organ/O in organs)
			for(var/wound/W in O.wounds)
				W.on_life()
		life_ticks = 0
	else
		life_ticks += 1
	*/

	for(var/obj/item/organ/O in organs)
		for(var/wound/W in O.wounds)
			W.on_life()

	return .

/mob/living/advanced/adjust_brute_loss(var/value)
	if(value > 0)
		health_regen_delay = max(health_regen_delay,300)
	return ..()

/mob/living/advanced/adjust_tox_loss(var/value)
	if(value > 0)
		health_regen_delay = max(health_regen_delay,300)
	return ..()

/mob/living/advanced/adjust_oxy_loss(var/value)
	if(value > 0)
		health_regen_delay = max(health_regen_delay,300)
	return ..()

/mob/living/advanced/adjust_burn_loss(var/value)
	if(value > 0)
		health_regen_delay = max(health_regen_delay,300)
	return ..()

/mob/living/advanced/on_life_client()

	..()

	if(automatic_ticks != 0)
		automatic_ticks = Clamp(automatic_ticks - 1,0,5)
	else

		var/set_tick = FALSE

		if(attack_flags & ATTACK_HELD_RIGHT)
			if(!do_automatic_left())
				attack_flags &= ~ATTACK_HELD_RIGHT
			else
				set_tick = TRUE

		if(attack_flags & ATTACK_HELD_LEFT)
			if(!do_automatic_right())
				attack_flags &= ~ATTACK_HELD_LEFT
			else
				set_tick = TRUE

		if(set_tick)
			automatic_ticks = 5


/mob/living/advanced/Initialize()

	if(!client || client.savedata.loaded_data["tutorial"])
		add_species_organs()
		add_species_colors()
		update_icon()
	else
		client.savedata.apply_data_to_mob(src)

	add_species_buttons()
	add_species_health_elements()

	..()

	update_health_element_icons(TRUE,TRUE,TRUE)
	update_all_blends()

/mob/living/advanced/proc/heal_all_organs(var/brute,var/burn,var/tox,var/oxy) //TODO: FIX THIS, IT'S BROKEN.

	var/list/damaged_organs = list()

	var/total_brute = 0
	var/total_burn = 0
	var/total_tox = 0
	var/total_oxy = 0

	for(var/organ_id in labeled_organs)

		var/obj/item/organ/O = labeled_organs[organ_id]

		var/brute_loss = O.get_brute_loss()
		var/burn_loss = O.get_burn_loss()
		var/tox_loss = O.get_tox_loss()
		var/oxy_loss = O.get_oxy_loss()

		damaged_organs[organ_id] = list()

		if(brute_loss)
			damaged_organs[organ_id][BRUTE] = brute_loss

		if(burn_loss)
			damaged_organs[organ_id][BURN] = burn_loss

		if(tox_loss)
			damaged_organs[organ_id][TOX] = tox_loss

		if(oxy_loss)
			damaged_organs[organ_id][OXY] = oxy_loss

		total_brute += brute_loss
		total_burn += burn_loss
		total_tox += tox_loss
		total_oxy += oxy_loss

	var/total_healed = 0

	for(var/organ_id in damaged_organs)
		var/obj/item/organ/O = labeled_organs[organ_id]
		if(damaged_organs[organ_id][BRUTE] && total_brute > 0 && brute > 0)
			var/heal_amount = (damaged_organs[organ_id][BRUTE] / total_brute) * brute
			O.adjust_brute_loss(-heal_amount)
			total_healed += heal_amount
		if(damaged_organs[organ_id][BURN]  && total_burn > 0 && burn > 0)
			var/heal_amount = (damaged_organs[organ_id][BURN] / total_burn) * burn
			O.adjust_burn_loss(-heal_amount)
			total_healed += heal_amount
		if(damaged_organs[organ_id][TOX]  && total_tox > 0 && tox > 0)
			var/heal_amount = (damaged_organs[organ_id][TOX] / total_tox) * tox
			O.adjust_tox_loss(-heal_amount)
			total_healed += heal_amount
		if(damaged_organs[organ_id][OXY]  && total_oxy > 0 && oxy > 0)
			var/heal_amount = (damaged_organs[organ_id][OXY] / total_oxy) * oxy
			O.adjust_oxy_loss(-heal_amount)
			total_healed += heal_amount

	update_health(-total_healed,src,do_update = FALSE)

	return total_healed

/mob/living/advanced/proc/adjust_mana(var/adjust_value)
	var/old_value = mana_current
	var/new_value = Clamp(mana_current + adjust_value,0,mana_max)

	if(old_value != new_value)
		mana_current = new_value
		return new_value - old_value

	return FALSE

/mob/living/advanced/proc/adjust_stamina(var/adjust_value)
	var/old_value = stamina_current
	var/new_value = Clamp(stamina_current + adjust_value,0,stamina_max)

	if(old_value != new_value)
		stamina_current = new_value
		return new_value - old_value

	return FALSE

/mob/living/advanced/proc/add_outfit(var/outfit_id,var/soul_bound=FALSE)

	var/outfit/spawning_outfit = all_outfits[outfit_id]

	if(!spawning_outfit)
		return FALSE

	for(var/key in spawning_outfit.spawning_clothes)
		var/obj/item/clothing/C = new key(get_turf(src))
		add_worn_item(C)
		if(soul_bound)
			C.soul_bound = TRUE

	return TRUE

/mob/living/advanced/proc/add_worn_item(var/obj/item/clothing/C)
	for(var/obj/inventory/I in inventory)
		if(I.add_worn_object(C,FALSE))
			return TRUE

	return FALSE

/mob/living/advanced/proc/remove_worn_item(var/obj/item/clothing/C)
	for(var/obj/inventory/I in inventory)
		if(I.remove_object(C))
			return TRUE

	return FALSE

/mob/living/advanced/proc/add_species_colors()

	if(mob_species.default_color_skin)
		change_organ_visual("skin", desired_color = mob_species.default_color_skin)

	if(mob_species.default_color_eye)
		change_organ_visual("eye", desired_color = mob_species.default_color_eye)

	if(mob_species.default_color_hair && mob_species.default_icon_hair && mob_species.default_icon_state_hair)
		change_organ_visual("hair_head", desired_icon = mob_species.default_icon_hair, desired_icon_state = mob_species.default_icon_state_hair, desired_color = mob_species.default_color_hair)
		change_organ_visual("hair_face", desired_color = mob_species.default_color_hair)

	if(mob_species.default_color_detail)
		change_organ_visual("skin_detail", desired_color = mob_species.default_color_detail)

	if(mob_species.default_color_glow)
		change_organ_visual("skin_glow", desired_color = mob_species.default_color_glow)

/mob/living/advanced/proc/change_organ_visual(var/desired_id, var/desired_icon,var/desired_icon_state,var/desired_color,var/desired_blend, var/desired_type,var/desired_layer,var/debug_message)
	for(var/obj/item/organ/O in organs)
		if(!length(O.additional_blends))
			continue
		O.change_blend(desired_id, desired_icon, desired_icon_state, desired_color, desired_blend, desired_type, desired_layer, debug_message)

/mob/living/advanced/proc/update_gender()
	remove_all_organs()
	add_species_organs()
	add_species_colors()

/mob/living/advanced/proc/update_species()

	if(mob_species.genderless)
		gender = NEUTER

	update_gender()

/mob/living/advanced/can_sprint()
	if(stamina_current <= 0)
		return FALSE

	return ..()

/* OLD MOVEMENT
/mob/living/advanced/do_move(var/turf/new_loc,var/movement_override = 0)
	. = ..()
	if(.)
		add_skill_xp(SKILL_ATHLETICS,1)
		stamina_current = max(0,stamina_current - 1)
		return .
	else
		return FALSE
*/

/mob/living/advanced/proc/pickup(var/obj/item/I,var/left = FALSE)

	if(left_hand && right_hand)
		if(left)
			return left_hand.add_held_object(I)
		else
			return right_hand.add_held_object(I)
	else
		if(left_hand)
			return left_hand.add_held_object(I)
		else if(right_hand)
			return right_hand.add_held_object(I)

	return FALSE

/mob/living/advanced/proc/get_held_left()
	if(left_hand)
		return left_hand.get_top_held_object()
	return null

/mob/living/advanced/proc/get_held_right()
	if(right_hand)
		return right_hand.get_top_held_object()
	return null