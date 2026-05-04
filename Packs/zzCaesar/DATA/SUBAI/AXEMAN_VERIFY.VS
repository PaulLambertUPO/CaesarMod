//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
int pop_cost;

this = objs[0].AsBuilding();
set = .settlement;
pop_cost = cmdcost_pop;

reasonText = rollover() + Translatef(" (currently %s1)", EnvReadInt(.player, "MaxAxemen"));

if (cmdcost_gold > set.gold)
	reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough gold");
if (cmdcost_food > set.food)
	reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough food");
if (pop_cost > 0) {
	int min_pop;
	min_pop = GetConst("MinPopulation");
	if (set.population - pop_cost < min_pop)
		reasonText = reasonText + "\n<color 255 0 0>" + Translatef("The current population is under the minimum of %s1 people", min_pop + pop_cost);
}

return true;