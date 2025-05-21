//bool, ObjList objs, str OUT reasonText

Building this;
str class, dest;
bool unaffordable = false;

dest = cmdparam;
class = ParseStr(dest, dest);

this = objs[0].AsBuilding();

if (cmdcost_gold > .settlement.gold)
	unaffordable = true;
else if (cmdcost_food > .settlement.food)
	unaffordable = true;
else if (cmdcost_pop > 0)
	if (.settlement.population - cmdcost_pop < GetConst("MinPopulation"))
		unaffordable = true;

if (class != "")
	reasonText = rollover(this, class, unaffordable);
else
	reasonText = rollover(this, unaffordable);

return true;