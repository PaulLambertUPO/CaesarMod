//bool, ObjList objs, str OUT reasonText

Building this;
str ship_class;
int race;

this = objs[0].AsBuilding();

ship_class = cmdparam;
race = GetPlayerRace(.player);

if (race == RepublicanRome) {
	if (ship_class != "ShipRome")
		return false;
}
else if (race == Egypt) {
	if (ship_class != "ShipEgypt")
		return false;
}
else if (ship_class != "ShipL")
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

	reasonText = rollover(this, ship_class, unaffordable);
	return true;
}

return false;