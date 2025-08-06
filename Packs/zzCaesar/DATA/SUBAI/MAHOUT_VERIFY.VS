//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();

set = .settlement;

reasonText = rollover(this, false) + Translatef(" (currently %s1)", EnvReadInt(.player, "MaxElephants"));

if (IsResearched(set, "People's Assembly")) {
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
else
	reasonText = reasonText + "\n<color 255 0 0>" + Translatef("Requires %s1", "People's Assembly");

return false;