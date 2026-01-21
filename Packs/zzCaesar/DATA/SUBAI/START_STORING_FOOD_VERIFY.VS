//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();
set = .settlement;

if (EnvReadInt(set, "IsStoring") != 1)
	if (IsResearched(set, "Trade Routes")) {
		bool unaffordable = false;

		if (cmdcost_gold > set.gold)
			unaffordable = true;
		else if (cmdcost_food > set.food)
			unaffordable = true;
		else if (cmdcost_pop > 0)
			if (set.population - cmdcost_pop < GetConst("MinPopulation"))
				unaffordable = true;

		reasonText = rollover(this, unaffordable);
		return true;
	}
	else
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Trade Routes");

return false;