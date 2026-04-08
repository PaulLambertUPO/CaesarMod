//bool, ObjList objs, str OUT reasonText
//cmdparam: "number_to_train, max_param, unit_class, research, research_building"

Building this;
Settlement set;
int plr, number_to_train;
str dest, max_param, unit_class, research, research_building;

this = objs[0].AsBuilding();
set = .settlement;

plr = .player;

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
unit_class = ParseStr(dest, dest);
research = ParseStr(dest, dest);
research_building = ParseStr(dest, dest);

if (EnvReadString(set, research) == "researched" || EnvReadString(plr, research) == "researched") {//do not use IsResearched because there are some researches that set different values from their command name
	int max_units, curr_units;

	if (max_param == "elephant")
		max_units = EnvReadInt(plr, "MaxElephants");
	else if (max_param == "huntress")
		max_units = EnvReadInt(plr, "MaxHuntresses");
	else if (max_param == "axeman")
		max_units = EnvReadInt(plr, "MaxAxemen");
	else if (max_param == "teutonrider")
		max_units = EnvReadInt(plr, "MaxTeutonRiders");
	else if (max_param == "maceman")
		max_units = EnvReadInt(plr, "MaxMacemen");
	else if (max_param == "myrmidon")
		max_units = EnvReadInt(plr, "MaxMyrmidons");
	else if (max_param == "mountaineer")
		max_units = MAX(10, Str2Int(EnvReadString(plr, "MaxMountaineers")));
	else if (max_param == "liberatus")
		max_units = 20;
	else
		max_units = Str2Int(max_param);

	if (max_param == "teutonrider")
		curr_units = number_to_train + Count(plr, "TTeutonRider") + Count(plr, "TTeutonArcher") + Count(plr, "TTeutonWolf") + EnvReadInt(plr, "QueuedBuild/" + unit_class);
	else if (max_param == "liberatus")
		curr_units = number_to_train + Count(plr, "RLiberatus") + EnvReadInt(plr, "QueuedBuild/RLiberatus") + EnvReadInt(plr, "QueuedBuild/RLiberatusPunic");
	else
		curr_units = number_to_train + Count(plr, unit_class) + EnvReadInt(plr, "QueuedBuild/" + unit_class);

	if (curr_units <= max_units) {
		reasonText = rollover(this, unit_class, false) + "\n" + Translatef("(you cannot have more than %s1, currently %s2)", max_units, curr_units - number_to_train);

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

		return true;
	}

	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("You cannot have more than %s1 (currently %s2)", max_units, curr_units - number_to_train);
}
else if (research_building != "")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", research, research_building);
else
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);

return false;