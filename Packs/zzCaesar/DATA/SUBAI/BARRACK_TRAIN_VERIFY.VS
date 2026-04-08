//bool, ObjList objs, str OUT reasonText

Barrack this;
Settlement set;
str dest, unit_class, research;

this = objs[0].AsBarrack();
set = .settlement;

dest = cmdparam;
unit_class = ParseStr(dest, dest);
research = ParseStr(dest, dest);

if (EnvReadString(set, research) == "researched") {//do not use IsResearched because there are some researches that set different values from their command name
	bool unaffordable = false;

	if (cmdcost_gold > set.gold)
		unaffordable = true;
	else if (cmdcost_food > set.food)
		unaffordable = true;
	else if (cmdcost_pop > 0)
		if (set.population - cmdcost_pop < GetConst("MinPopulation"))
			unaffordable = true;

	reasonText = rollover(this, unit_class, unaffordable);

	return true;
}

if (unit_class == "RGladiator")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
else if (unit_class == "RGladiatorPunic")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
else if (unit_class == "EAnubisWarrior")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
else if (unit_class == "EHorusWarrior")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
else
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Blacksmith", research);

return false;