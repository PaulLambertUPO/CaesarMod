//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
str unit_class, dest;
bool unaffordable = false;

this = objs[0].AsBuilding();
set = .settlement;

dest = cmdparam;
unit_class = ParseStr(dest, dest);

if (cmdcost_gold > set.gold)
	unaffordable = true;
else if (cmdcost_food > set.food)
	unaffordable = true;
else if (cmdcost_pop > 0)
	if (set.population - cmdcost_pop < GetConst("MinPopulation"))
		unaffordable = true;

if (unit_class != "")
	reasonText = rollover(this, unit_class, unaffordable);
else
	reasonText = rollover(this, unaffordable);

return true;