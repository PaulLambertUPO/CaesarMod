//bool, ObjList objs, str OUT reasonText

Building this;
str dest;

this = objs[0].AsBuilding();
dest = cmdparam;

if (IsResearched(.player, "Tame horses")) {
	Settlement set;
	int horses;

	set = .settlement;

	horses = EnvReadInt(set, "EEE_IVillageNumberHorses");

	if (horses > 0) {
		if (horses - .CmdCount("callIScout") > 0) {
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
		reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("There are already enough queued commands to use all horses");
	}
	else
		reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("Requires 1 horse");
}
else
	reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Tame horses");

return false;