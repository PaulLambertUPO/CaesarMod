//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	int race;

	race = GetPlayerRace(.player);

	if (race == RepublicanRome) {
		if (cmdparam != "ShipRome")
			return false;
	}
	else if (race == Egypt) {
		if (cmdparam != "ShipEgypt")
			return false;
	}
	else if (cmdparam != "ShipL")
		return false;

	{
		Settlement set;
		bool unaffordable = false;

		set = .settlement;

		if (cmdcost_gold > set.gold)
			unaffordable = true;
		else if (cmdcost_food > set.food)
			unaffordable = true;
		else if (cmdcost_pop > 0)
			if (set.population - cmdcost_pop < GetConst("MinPopulation"))
				unaffordable = true;

		reasonText = rollover(this, cmdparam, unaffordable);//cmdparam must be equal to the ship class
		return true;
	}
}

return false;