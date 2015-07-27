DIFFICULTY = {}

DIFFICULTY.EASY = 
{
	locale_key = "homeworld-difficulty-easy",
	description_lines = 5,
	population_growth_modifier = 2.0,
	population_decline_modifier = 1.0,
	need_max_per_min_modifier = 0.5,
	reward_amount_modifier = 1.25,
	pollution_affect_modifier = 0.5,
	finite_water = false
}

DIFFICULTY.NORMAL = 
{
	locale_key = "homeworld-difficulty-normal",
	description_lines = 2,
	population_growth_modifier = 1.0,
	population_decline_modifier = 1.0,
	need_max_per_min_modifier = 1.0,
	reward_amount_modifier = 1.0,
	pollution_affect_modifier = 1.0,
	finite_water = true
}

DIFFICULTY.HARD = 
{
	locale_key = "homeworld-difficulty-hard",
	description_lines = 6,
	population_growth_modifier = 0.75,
	population_decline_modifier = 2.0,
	need_max_per_min_modifier = 2.0,
	reward_amount_modifier = 0.75,
	pollution_affect_modifier = 1.42,
	finite_water = true
}

DIFFICULTY_SORTED = 
{
	DIFFICULTY.EASY,
	DIFFICULTY.NORMAL,
	DIFFICULTY.HARD
}