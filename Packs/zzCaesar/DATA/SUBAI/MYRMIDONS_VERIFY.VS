//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();

set = .settlement;

if (IsResearched(set, "Olympic Games")) {
	int player_max_myrmidons, global_max_myrmidons;

	player_max_myrmidons = EnvReadInt(.player, "MaxMyrmidons");
	global_max_myrmidons = GetConst("MaxMyrmidonsValue");

	if (player_max_myrmidons < global_max_myrmidons) {
		reasonText = rollover(this, false) + Translatef(" (currently %s1)", player_max_myrmidons);

		if (cmdcost_gold > set.gold)
			reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough gold");
		if (cmdcost_food > set.food)
			reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough food");
		if (cmdcost_pop > 0) {
			int min_pop;
			min_pop = GetConst("MinPopulation");
			if (set.population - cmdcost_pop < min_pop)
				reasonText = reasonText + "\n<color 255 0 0>" + Translatef("The current population is under the minimum of %s1 people", min_pop + cmdcost_pop);
		}

		if (EnvReadString(this, "researching") != "yes")
			return true;
	}
	else
		reasonText = rollover(this, false) + "<color 255 0 0>\n" + Translatef("You cannot have more than %s1", global_max_myrmidons);
}
else
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Olympic Games");

return false;