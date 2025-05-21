//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();
set = .settlement;

if (IsResearched(set, "Offer to Gods"))
	if (EnvReadString(set, "ApolloProtectionP" + .player) != "researched")
		if (EnvReadInt(set, "ApolloProtectionTimer") <= 0)
			if (EnvReadString(this, "researching") != "yes") {
				ObjList gates;
				bool unaffordable = false;
				int i;

				gates = set.ObjectsAround("Gate");

				for (i = 0; i < gates.count; i += 1)
					if (gates[i].AsGate().IsBroken()) {
						reasonText = Translate(rollover(this, false)) + "\n<color 255 0 0>" + Translate("One or more gates are broken");
						return false;
					}

				if (cmdcost_gold > set.gold)
					unaffordable = true;
				else if (cmdcost_food > set.food)
					unaffordable = true;
				else if (cmdcost_pop > 0)
					if (set.population - cmdcost_pop < GetConst("MinPopulation"))
						unaffordable = true;

				reasonText = rollover(this, unaffordable);
				return true;
			}
			else
				reasonText = rollover(this, true);
		else
			reasonText = rollover(this, "Already available");
	else
		reasonText = rollover(this, "Already available");
else
	reasonText = Translate(rollover(this, false)) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Offer to Gods");

return false;