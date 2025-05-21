//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid)
	if (EnvReadString(this, "researching") != "yes") {
		Settlement set;
		int count_units;

		set = .settlement;

		if (set.IsValid) {
			ObjList l;
			Unit u;
			int i;

			l = set.ObjectsAround("Military");
			l.ClearDead();
			for (i = 0; i < l.count && count_units < 5; i += 1) {
				u = l[i].AsUnit();
				if (u.IsValid)
					if (!.IsEnemy(u))
						if (!u.HasItem(cmdparam))
							if (!u.IsSentry)
								if (!u.IsHeirOf("Hero"))
									count_units += 1;
			}
		}

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

		reasonText = rollover(this, false) + "\n<color 255 0 0 >" + Translate("Requires at least 5 warriors without that charm around the Townhall");
	}
	else
		reasonText = rollover(this, true);

return false;