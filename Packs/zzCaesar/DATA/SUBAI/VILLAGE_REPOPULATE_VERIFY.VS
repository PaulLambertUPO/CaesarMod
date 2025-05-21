//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	Settlement set;
	int min_pop;

	set = .settlement;
	min_pop = GetConst("MinPopulation");

	if (.IsBroken() || set.population < min_pop) {
		bool unaffordable = false;

		if (cmdcost_gold > set.gold)
			unaffordable = true;
		else if (cmdcost_food > set.food)
			unaffordable = true;
		else if (cmdcost_pop > 0)
			if (set.population - cmdcost_pop < min_pop)
				unaffordable = true;

		reasonText = rollover(this, unaffordable);

		return true;
	}
}

return false;