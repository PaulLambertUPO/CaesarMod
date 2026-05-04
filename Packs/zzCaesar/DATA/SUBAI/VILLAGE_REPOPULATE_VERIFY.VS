//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.command != "repopulate") {
	bool in_need = false;

	if (.IsBroken)
		in_need = true;
	else {
		Settlement set;
		int min_pop;

		set = .settlement;
		min_pop = GetConst("MinPopulation");

		if (set.max_population >= min_pop)
			if (set.population < min_pop)
				in_need = true;
	}

	if (in_need) {
		reasonText = rollover(this, true);
		return true;
	}
}

return false;