//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
int i, j;

this = objs[0].AsBuilding();
set = .settlement;

i = set.GetMaxSentries();
j = set.GetNumSentries();

reasonText = rollover() + "\n" + Translatef("(you cannot have more than %s1, currently %s2)", i, j);

if (i - j > 0) {
	i = cmdcost_pop;

	if (cmdcost_gold > set.gold)
		reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough gold");
	if (cmdcost_food > set.food)
		reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough food");
	if (i > 0) {
		j = GetConst("MinPopulation");
		if (set.population - i < j)
			reasonText = reasonText + "\n<color 255 0 0>" + Translatef("The current population is under the minimum of %s1 people", j + i);
	}

	return true;
}

reasonText = reasonText + "\n<color 255 0 0>" + Translate("No additional sentries can be hired");

return false;