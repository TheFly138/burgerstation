proc/time_prob(var/value)
	return prob(value / FPS_SERVER)


/proc/get_luck_calc(var/atom/positive,var/positive_luck_mul,var/atom/negative,var/negative_luck_mul)
	var/base_prob = 0

	if(positive && positive_luck_mul)
		if(is_living(positive))
			var/mob/living/L = positive
			var/luck = L.get_attribute_level(ATTRIBUTE_LUCK)
			base_prob += (luck-50)*positive_luck_mul

	if(negative && negative_luck_mul)
		if(is_living(negative))
			var/mob/living/L = negative
			var/luck = L.get_attribute_level(ATTRIBUTE_LUCK)
			base_prob += (luck-50)*negative_luck_mul

	return base_prob