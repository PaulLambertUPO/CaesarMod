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

	if (IsResearched(set, research)) {//sacred legion
		research = ParseStr(dest, dest);

		if (IsResearched(.player, research)) {//dark rituals
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
	}

	reasonText = rollover(this, class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);
}

return false;