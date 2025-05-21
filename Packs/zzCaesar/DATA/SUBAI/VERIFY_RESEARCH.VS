//bool, ObjList objs, str OUT reasonText
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, NamePlr, <research>, NameSet, <research>, <value>, SetsPlr, <env>, <value>, SetsSet, <env>, <value>]

Building this;
Settlement set;
str dest, token, name, value;
int player;
bool is_tribute = false;

this = objs[0].AsBuilding();
set = .settlement;

dest = cmdparam;

player = .player;

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NameSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);

		if (name == "Transition to Empire") {
			bool not_researchable = true;
			if (GetTime() >= 2400000)
				if (IsResearched(player, "Advanced Training"))
					if (IsResearched(player, "Veteran Offence"))
						if (IsResearched(player, "Veteran Defence"))
							if (IsResearched(player, "Veteran Health"))
								if (IsResearched(player, "Nobility"))
									not_researchable = false;
			if (not_researchable) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Advanced training, Veteran offence, Veteran defence, Veteran health, Nobility and 40 game minutes");
				return false;
			}
		}
		else if (name == "Legendary Heroes") {
			bool not_researchable = true;
			if (GetTime() >= 2700000)
				if (IsResearched(player, "Special training"))
					if (IsResearched(set, "Trident Warrior Exp3"))
						if (IsResearched(player, "Warrior Tales"))
							if (IsResearched(player, "Battle tactics"))
								not_researchable = false;
			if (not_researchable) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Special training, Trident Warrior Experience III, Warrior Tales, Battle tactics and 45 game minutes");
				return false;
			}
		}
		else if (name == "Gambler's All-in")
			if (GetTime() - EnvReadInt(set, "LastAllIn") < 180000) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("At least 3 minutes must pass between each attempt");
				return false;
			}

		if (EnvReadString(set, name) == "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default")
				reasonText = rollover(this, "Already available");
			else
				reasonText = Translate(value);
			return false;
		}
		if (EnvReadString(this, "researching") == "yes") {
			reasonText = rollover(this, true);
			return false;
		}
	}
	else if (token == "NamePlr") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);

		if (name == "Statue of Amon-Ra") {
			bool not_researchable = true;
			if (IsResearched(set, "Cult of Anubis"))
				if (IsResearched(set, "Cult of Horus"))
					not_researchable = false;
			if (not_researchable) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Cult of Anubis and Cult of Horus");
				return false;
			}
		}
		else if (name == "Tribute") {
			if (EnvReadString(player, name) != "researched") {//do not use IsResearched here because all tribute commands have a prefix in their name based on race
				int i, delay, time, gold;
				str times, values;

				is_tribute = true;
				times = GetConstStr("TributeTimes");
				values = GetConstStr("TributeGold");
				delay = GetConst("TributeDuration") * 1000;

				i = GetTime() + delay;

				while (times != "") {
					int old_gold;
					old_gold = gold;
					time = Str2Int(ParseStr(times, times)) * 60000;
					gold = Str2Int(ParseStr(values, values));
					if (i < time) {
						gold = old_gold;
						break;
					}
				}

				reasonText = Translatef(rollover(this, true), gold);

				if (EnvReadString(player, name) == "researching")
					return false;
			}
			else {
				reasonText = rollover_desc(this, "Already collected", false);
				return false;
			}
		}
		if (EnvReadString(player, name) == "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default")
				reasonText = rollover(this, "Already available");
			else
				reasonText = Translate(value);
			return false;
		}
		if (EnvReadString(this, "researching") == "yes") {
			if (!is_tribute)
				reasonText = rollover(this, true);
			return false;
		}
	}
	else if (token == "ReqSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (EnvReadString(set, name) != "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default") {
				while (dest != "") {
					str t, n;
					t = ParseStr(dest, dest);
					n = ParseStr(dest, dest);
					if (t == "NamePlr")
						if (n == "Tribute") {
							int i, delay, time, gold;
							str times, values;

							times = GetConstStr("TributeTimes");
							values = GetConstStr("TributeGold");
							delay = GetConst("TributeDuration") * 1000;

							i = GetTime() + delay;

							while (times != "") {
								int old_gold;
								old_gold = gold;
								time = Str2Int(ParseStr(times, times)) * 60000;
								gold = Str2Int(ParseStr(values, values));
								if (i < time) {
									gold = old_gold;
									break;
								}
							}
							reasonText = Translatef(rollover(this, false), gold) + "\n<color 255 0 0>" + Translatef("Requires %s1", name);
							return false;
						}
				}
				reasonText = Translate(rollover(this, false)) + "\n<color 255 0 0>" + Translatef("Requires %s1", name);
			}
			else
				reasonText = Translate(value);
			return false;
		}
	}
	else if (token == "ReqPlr") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (EnvReadString(player, name) != "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default")
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", name);
			else
				reasonText = Translate(value);
			return false;
		}
	}
	else if (token == "NReqSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (EnvReadString(set, name) == "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default") {
				if (.race == Carthage && name == "Specialization")
					reasonText = rollover(this, true);
				else
					reasonText = rollover(this, "Already available");
			}
			else
				reasonText = Translate(value);
			return false;
		}
	}
	else if (token == "break")//used only by Spartan Training to manage the unlock of Training and Advanced Training
		break;
}

if (!is_tribute) {
	bool unaffordable = false;

	if (cmdcost_gold > set.gold)
		unaffordable = true;
	else if (cmdcost_food > set.food)
		unaffordable = true;
	else if (cmdcost_pop > 0)
		if (set.population - cmdcost_pop < GetConst("MinPopulation"))
			unaffordable = true;

	reasonText = rollover(this, unaffordable);
}

return true;