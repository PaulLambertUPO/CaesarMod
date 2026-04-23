//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
int max, curr;

this = objs[0].AsBuilding();
set = .settlement;

max = set.GetMaxSentries();
curr = set.GetNumSentries();

reasonText = rollover(this, false) + "\n" + Translatef("(you cannot have more than %s1, currently %s2)", max, curr);

if (max - curr > 0) {
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

reasonText = reasonText + "\n<color 255 0 0>" + Translate("No additional sentries can be hired");

return false;