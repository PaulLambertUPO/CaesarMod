//bool, ObjList objs, str OUT reasonText
//cmdparam: [ReqSet, <research>, <explanation>, ReqPlr, <research>, <explanation>, SetsSet, <env>, <value>, SetsPlr, <env>, <value>, NameSet, <research>, <value>, NamePlr, <research>, <value>]

Building this;
Settlement set;
str dest, token, name, value, env_level;
int plr;
bool is_tribute = false;

this = objs[0].AsBuilding();
set = .settlement;

dest = cmdparam;

plr = .player;

while (dest != "") {
	token = ParseStr(dest, dest);
	if (token == "NameSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (name == "Transition to Empire") {
			bool not_researchable = true;
			if (GetTime() >= 2400000)
				if (IsResearched(plr, "Rome Training 2"))
					if (IsResearched(plr, "Veteran Offence"))
						if (IsResearched(plr, "Veteran Defence"))
							if (IsResearched(plr, "Veteran Health"))
								if (IsResearched(plr, "Nobility"))
									not_researchable = false;
			if (not_researchable) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Advanced training, Veteran offence, Veteran defence, Veteran health, Nobility and 40 game minutes");
				return false;
			}
		}
		else if (name == "Legendary Heroes") {
			bool not_researchable = true;
			if (GetTime() >= 2700000)
				if (IsResearched(plr, "Gaul Training 3"))
					if (IsResearched(set, "Trident Warrior Exp3"))
						if (IsResearched(plr, "Warrior Tales"))
							if (IsResearched(plr, "Battle tactics"))
								not_researchable = false;
			if (not_researchable) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Special training, Trident Warrior Experience III, Warrior Tales, Battle tactics and 45 game minutes");
				return false;
			}
		}
		else if (name == "Gambler's All-in") {
			if (GetTime() - EnvReadInt(set, "LastAllIn") < 180000) {
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("At least 3 minutes must pass between each attempt");
				return false;
			}
		}
		else if (name == "Liberati guild")
			env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestLiberatusLevel"));
		else if (name == "Legendary Valkyries")
			env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestValkyrieLevel"));
		else if (name == "Shrine of Thor")
			env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestVikingLordLevel"));

		if (EnvReadString(set, name) == "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default")
				reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already available") + env_level;
			else if (value == "spec")
				reasonText = rollover(this, true) + env_level;
			else if (value != "")
				reasonText = Translate(value);
			return false;
		}
		if (EnvReadString(this, "researching") == "yes") {
			reasonText = rollover(this, true) + env_level;
			return false;
		}
		if (EnvReadString(set, name) == "researching") {//do not use IsResearching here because there might be some commands with a name/token that would not comply
			if (value == "spec")
				reasonText = rollover(this, true) + env_level;
			else
				reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already researching") + env_level;
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
		else if (name == "Tribute")
			if (EnvReadString(plr, name) != "researched") {//do not use IsResearched here because all tribute commands have a prefix in their name based on race
				int i, time, gold, old_gold;
				str times, values;

				is_tribute = true;
				times = GetConstStr("TributeTimes");
				values = GetConstStr("TributeGold");

				i = GetTime() + GetConst("TributeDuration") * 1000;

				while (times != "") {
					old_gold = gold;
					time = Str2Int(ParseStr(times, times)) * 60000;
					gold = Str2Int(ParseStr(values, values));
					if (i < time) {
						gold = old_gold;
						break;
					}
				}

				reasonText = Translatef(rollover(this, true), gold);
			}
			else {
				reasonText = rollover_desc(this, "<color 0 255 0>" + Translate("Already collected"), false);
				return false;
			}
		else if (name == "Mountain Clan Legacy")
			env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMountaineerLevel"));
		else if (name == "Tribute to Heracles")
			env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMyrmidonLevel"));

		if (EnvReadString(plr, name) == "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default")
				reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already available") + env_level;
			else if (value != "")
				reasonText = Translate(value);
			return false;
		}
		if (EnvReadString(this, "researching") == "yes") {
			if (!is_tribute)
				reasonText = rollover(this, true) + env_level;
			return false;
		}
		if (EnvReadString(plr, name) == "researching") {//do not use IsResearching here because there might be some commands with a name/token that would not comply
			if (!is_tribute)
				reasonText = rollover(this, false);
			reasonText = reasonText + "\n<color 0 255 0>" + Translate("Already researching") + env_level;
			return false;
		}
	}
	else if (token == "ReqSet") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (EnvReadString(set, name) != "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default") {
				str tk, nm;
				while (dest != "") {
					tk = ParseStr(dest, dest);
					if (tk == "NamePlr") {
						nm = ParseStr(dest, dest);
						if (nm == "Tribute") {
							int i, time, gold, old_gold;
							str times, values;

							times = GetConstStr("TributeTimes");
							values = GetConstStr("TributeGold");

							i = GetTime() + GetConst("TributeDuration") * 1000;

							while (times != "") {
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
						else if (nm == "Mountain Clan Legacy")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMountaineerLevel"));
						else if (nm == "Tribute to Heracles")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMyrmidonLevel"));
					}
					else if (tk == "NameSet") {
						nm = ParseStr(dest, dest);
						if (nm == "Liberati guild")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestLiberatusLevel"));
						else if (nm == "Legendary Valkyries")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestValkyrieLevel"));
						else if (nm == "Shrine of Thor")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestVikingLordLevel"));
					}
				}
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", name) + env_level;
			}
			else if (value != "")
				reasonText = Translate(value);
			return false;
		}
	}
	else if (token == "ReqPlr") {
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (EnvReadString(plr, name) != "researched") {//do not use IsResearched here because there might be some commands with a name/token that would not comply
			if (value == "default") {
				str tk, nm;
				while (dest != "") {
					tk = ParseStr(dest, dest);
					if (tk == "NamePlr") {
						nm = ParseStr(dest, dest);
						if (nm == "Mountain Clan Legacy")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMountaineerLevel"));
						else if (nm == "Tribute to Heracles")
							env_level = "\n<color 255 255 255>" + Translatef("Current best level: %s1", EnvReadInt(plr, "BestMyrmidonLevel"));
					}
				}
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", name) + env_level;
			}
			else if (value != "")
				reasonText = Translate(value);
			return false;
		}
	}
	else if (token == "SetsSet") {//used for Carthage specialization stop commands when sentry-related upgrades are being researched
		name = ParseStr(dest, dest);
		value = ParseStr(dest, dest);
		if (name == "Specialization")
			if (value == "")
				if (EnvReadString(this, "researching") == "yes") {
					reasonText = rollover(this, true) + env_level;
					return false;
				}
	}
	else if (token == "break")//used only by Spartan/Special Training
		break;
}

if (!is_tribute)
	reasonText = rollover(this, true) + env_level;

return true;