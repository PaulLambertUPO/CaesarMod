//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid) {
	str dest;

	dest = cmdparam;

	if (IsResearched(.player, "Tame horses")) {
		Settlement set;

		set = .settlement;

		if (EnvReadInt(set, "EEE_IVillageNumberHorses") >= 1) {
			bool unaffordable = false;

			if (cmdcost_gold > set.gold)
				unaffordable = true;
			else if (cmdcost_food > set.food)
				unaffordable = true;
			else if (cmdcost_pop > 0)
				if (set.population - cmdcost_pop < GetConst("MinPopulation"))
					unaffordable = true;

			reasonText = rollover(this, ParseStr(dest, dest), unaffordable);
			return true;
		}
		else
			reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("Requires one horse in the village");
	}
	else
		reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("Requires Tame horses");
}

return false;