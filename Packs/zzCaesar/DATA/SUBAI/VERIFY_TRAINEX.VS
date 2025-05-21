//bool, ObjList objs, str OUT reasonText
//cmdparam: "number_to_train, max_param, class, research, research_building"

Building this;
Settlement set;
int player, number_to_train;
str dest, max_param, class, research, research_building;

this = objs[0].AsBuilding();

set = .settlement;

player = .player;

dest = cmdparam;
number_to_train = Str2Int(ParseStr(dest, dest));
max_param = ParseStr(dest, dest);
class = ParseStr(dest, dest);
research = ParseStr(dest, dest);
research_building = ParseStr(dest, dest);

if (EnvReadString(set, research) == "researched" || EnvReadString(player, research) == "researched") {//do not use IsResearched because there are some researches that set different values from their command name
	int max_units, curr_units;

	if (max_param == "elephant")
		max_units = EnvReadInt(player, "MaxElephants") + 1;
	else if (max_param == "huntress")
		max_units = EnvReadInt(player, "MaxHuntresses");
	else if (max_param == "axemen")
		max_units = EnvReadInt(player, "MaxAxemen");
	else if (max_param == "teutonrider")
		max_units = EnvReadInt(player, "MaxTeutonRiders");
	else if (max_param == "macemen")
		max_units = EnvReadInt(player, "MaxMacemen");
	else if (max_param == "myrmidon")
		max_units = EnvReadInt(player, "MaxMyrmidons");
	else if (max_param == "mountaineer")
		max_units = MAX(10, Str2Int(EnvReadString(player, "MaxMountaineers")));
	else if (max_param == "liberatus")
		max_units = 20;
	else
		max_units = Str2Int(max_param);

	if (max_param == "teutonrider")
		curr_units = number_to_train + Count(player, "TTeutonRider") + Count(player, "TTeutonArcher") + Count(player, "TTeutonWolf") + EnvReadInt(player, "QueuedBuild/" + class) + EnvReadInt(this, "Build/" + class);
	else if (max_param == "liberatus")
		curr_units = number_to_train + Count(player, "RLiberatus") + EnvReadInt(player, "QueuedBuild/RLiberatus") + EnvReadInt(player, "QueuedBuild/RLiberatusPunic") + EnvReadInt(this, "Build/" + class);
	else
		curr_units = number_to_train + Count(player, class) + EnvReadInt(player, "QueuedBuild/" + class) + EnvReadInt(this, "Build/" + class);

	if (curr_units <= max_units) {
		reasonText = rollover(this, class, false) + "\n" + Translatef("(you cannot have more than %s1, currently %s2)", max_units, curr_units - number_to_train);

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
	reasonText = rollover(this, class, false) + "<color 255 0 0>\n" + Translatef("You cannot have more than %s1", max_units);
}
else if (research_building != "")
	reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", research, research_building);
else
	reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);

return false;