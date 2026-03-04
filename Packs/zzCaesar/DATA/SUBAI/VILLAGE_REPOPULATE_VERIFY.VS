//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.command != "repopulate") {
	Settlement set;
	int min_pop;
	bool in_need_unaffordable = false;

	set = .settlement;
	min_pop = GetConst("MinPopulation");

	if (.IsBroken)
		in_need_unaffordable = true;
	else if (set.max_population >= min_pop)
		if (set.population < min_pop)
			in_need_unaffordable = true;

	if (in_need_unaffordable) {
		in_need_unaffordable = false;

		if (cmdcost_gold > set.gold)
			in_need_unaffordable = true;
		else if (cmdcost_food > set.food)
			in_need_unaffordable = true;
		else if (cmdcost_pop > 0)
			if (set.population - cmdcost_pop < min_pop)
				in_need_unaffordable = true;

		reasonText = rollover(this, in_need_unaffordable);

		return true;
	}
}

return false;