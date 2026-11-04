//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;
str hero_class;
int i;

hero_class = cmdparam;

if (hero_class == "Caesar") {
	bool cannot_train = true;
	if (GetTime() >= 2400000) {
		this = objs[0].AsBuilding();
		set = .settlement;
		if (IsResearched(set, "Gladiator Shows")) {
			i = .player;
			if (IsResearched(i, "Rome Training 2"))
				if (IsResearched(i, "Veteran Offence"))
					if (IsResearched(i, "Veteran Defence"))
						if (IsResearched(i, "Veteran Health"))
							if (IsResearched(i, "Nobility"))
								if (IsResearched(i, "Roman Triumph"))
									cannot_train = false;
		}
	}
	if (cannot_train) {
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Gladiator shows, Advanced training, Veteran offence, Veteran defence, Veteran health, Nobility, Roman Triumph and 40 game minutes");
		return false;
	}
}
else {//Keltill and Larax
	bool cannot_train = true;
	if (GetTime() >= 2700000) {
		this = objs[0].AsBuilding();
		set = .settlement;
		if (IsResearched(set, "Fights"))
			if (IsResearched(set, "Trident Warrior Exp3")) {
				i = .player;
				if (IsResearched(i, "Gaul Training 3"))
					if (IsResearched(i, "Warrior Tales"))
						if (IsResearched(i, "Battle tactics"))
							if (IsResearched(i, "Legendary Heroes"))
								cannot_train = false;
			}
	}
	if (cannot_train) {
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Fights, Special training, Trident Warrior Experience III, Warrior Tales, Battle tactics, Legendary Heroes and 45 game minutes");
		return false;
	}
}

if (Count(i, hero_class) + EnvReadInt(i, "QueuedBuild/" + hero_class) < 1) {
	i = cmdcost_pop;

	reasonText = rollover(this, hero_class, false);

	if (cmdcost_gold > set.gold)
		reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough gold");
	if (cmdcost_food > set.food)
		reasonText = reasonText + "\n<color 255 0 0>" + Translate("Not enough food");
	if (i > 0) {
		int min_pop;
		min_pop = GetConst("MinPopulation");
		if (set.population - i < min_pop)
			reasonText = reasonText + "\n<color 255 0 0>" + Translatef("The current population is under the minimum of %s1 people", min_pop + i);
	}

	return true;
}

reasonText = rollover(this, hero_class, false) + "\n<color 255 0 0>" + Translatef("You cannot have more than %s1", 1);

return false;