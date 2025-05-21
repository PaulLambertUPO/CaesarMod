//bool, Settlement set, str tech

//called by specific tactic scripts (TS_...Tactic), this script manages the research of settlement/player upgrades

if (IsResearched(set, tech))
	return true;
if (IsResearched(set.player, tech))
	return true;
if (IsResearching(set, tech))
	return true;

if (set.CanResearch(tech))
	if (set.CanAfford(tech)) {
		int gold, food;
		if (GetCmdCost(tech, gold, food)) {
			set.SpentGoldOnTech(gold + food / 2);
			set.Research(tech);
			return true;//by returning true here, all bool variables in the scripts for researches with a NameSet value different from their respective command name are correctly managed
		}
	}

return false;