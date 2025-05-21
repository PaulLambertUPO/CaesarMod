//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	str dest, unit, specialization;

	dest = cmdparam;
	unit = ParseStr(dest, dest);
	specialization = ParseStr(dest, dest);

	if (specialization == "spec") {
		Settlement set;
		set = .settlement;
		if (EnvReadString(set, unit) == "researched") {//do not use IsResearched here because there are no commands with unit name
			bool unaffordable = false;
			if (cmdcost_gold > set.gold)
				unaffordable = true;
			else if (cmdcost_food > set.food)
				unaffordable = true;
			else if (cmdcost_pop > 0)
				if (set.population - cmdcost_pop < GetConst("MinPopulation"))
					unaffordable = true;
			reasonText = rollover(this, unit, unaffordable);
			return true;
		}
		return false;
	}

	if (specialization == "non-spec") {
		Settlement set;
		set = .settlement;
		if (EnvReadString(set, unit) != "researched") {//do not use IsResearched here because there are no commands with unit name
			bool unaffordable = false;
			if (cmdcost_gold > set.gold)
				unaffordable = true;
			else if (cmdcost_food > set.food)
				unaffordable = true;
			else if (cmdcost_pop > 0)
				if (set.population - cmdcost_pop < GetConst("MinPopulation"))
					unaffordable = true;
			reasonText = rollover(this, unit, unaffordable);
			return true;
		}
		return false;
	}

	reasonText = "Invalid command param: " + cmdparam;
	return true;
}

return false;