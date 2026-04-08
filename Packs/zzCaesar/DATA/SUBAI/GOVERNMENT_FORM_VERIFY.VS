//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();

set = .settlement;

if (IsResearched(set, "Olympic Games"))
	if (EnvReadString(this, "researching") != "yes") {
		str gov_form;
		int plr;

		gov_form = cmdparam;
		plr = .player;

		if (EnvReadString(plr, gov_form + "_researching") != "yes")
			if (EnvReadString(plr, "GovernmentForm") != gov_form) {
				bool unaffordable = false;

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
				reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already available");
		else
			reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already researching");
	}
	else
		reasonText = rollover(this, true);
else
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Olympic Games");

return false;