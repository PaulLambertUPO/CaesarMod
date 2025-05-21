//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	Settlement set;
	str dest, class, research;

	set = .settlement;

	dest = cmdparam;

	class = ParseStr(dest, dest);
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

		reasonText = rollover(this, class, unaffordable);

		return true;
	}

	if (class == "RGladiator")
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
	else if (class == "RGladiatorPunic")
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
	else if (class == "CNoble")
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);
	else if (class == "EAnubisWarrior")
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
	else if (class == "EHorusWarrior")
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
	else
		reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Blacksmith", research);
}

return false;