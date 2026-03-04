//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (EnvReadString(this, "researching") != "yes") {
	Settlement set;

	set = .settlement;

	if (set.IsValid) {
		ObjList ol;
		Unit u;
		str charm;
		int i, count_units;

		charm = cmdparam;

		ol = set.ObjectsAround("Military");

		for (i = ol.count - 1; i >= 0; i -= 1) {
			u = ol[i].AsUnit();
			if (u.IsAlive)
				if (!.IsEnemy(u))
					if (u.free_item_slots > 0)
						if (!u.HasItem(charm))
							if (!u.IsSentry)
								if (!u.IsHeirOf("Hero")) {
									count_units += 1;
									if (count_units >= 5) {
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
								}
		}

		reasonText = rollover(this, false) + "\n<color 255 0 0 >" + Translate("Requires at least 5 warriors without that charm around the Townhall");
	}
}
else
	reasonText = rollover(this, true);

return false;