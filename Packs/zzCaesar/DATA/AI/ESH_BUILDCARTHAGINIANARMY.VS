//void, Settlement set

//called from ES_Stronghold, this script sets "nBuildType" and "nBuildCount" in the settlement environment

int nAssUnderFire;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold

if (set.gold >= 800 || nAssUnderFire > 0) {
	int AIPlayer, nArmyBuilds, nMilUnits;
	bool bBuildMercArmy, bBuildArmy;

	AIPlayer = set.player;

	nArmyBuilds = EnvReadInt(set, "nArmyBuilds");//set in ES_Stronghold
	nMilUnits = MilUnits(AIPlayer);

	//decide whether to build army at all
	if (nAssUnderFire > 0) {
		bBuildArmy = true;
		bBuildMercArmy = set.population <= GetConst("MinPopulation");
	}
	else if (EnvReadInt(set, "FreezeArmyBuild") > 0)
		return;
	else if (nArmyBuilds <= 0) {
		bBuildArmy = true;
		bBuildMercArmy = set.population <= GetConst("MinPopulation");
	}
	else {
		int pop_perc;
		if (nMilUnits <= 20)
			pop_perc = 35;
		else if (nArmyBuilds <= 10)
			pop_perc = 50;
		else
			pop_perc = 65;
		bBuildArmy = true;
		bBuildMercArmy = set.population < set.max_population * pop_perc / 100;//do not recruit nobles but only mercenaries if below this population
	}

	if (bBuildArmy) {
		int nType;
		str strTech;

		nType = -1;

		//5-CNoble management (chance to recruit them instead of mercenaries)
		if (!bBuildMercArmy) {
			int r;
			if (set.gold >= 5000)
				r = 2;
			else
				r = 5;
			if (rand(r) == 0) {
				nType = 5;
				strTech = "Sacred Legion";
				if (!IsResearched(set, strTech)) {
					if (!IsResearching(set, strTech)) {
						EnvWriteString(set, "strTech", strTech);
						set.AIRun("ESH_NeedTech.vs");
					}
					nType = -1;//while sacred legion is not completed, recruit one of the other units
				}
			}
		}

		//check current specialization if nobles are not desired/recruitable
		if (nType < 0)
			if (EnvReadString(set, "Specialization") != "")
				nType = EnvReadInt(set, "SpecializedUnit") - 1;//0-4 or 6

		if (nType < 0) {//nothing is specialized -> choose an affordable unit research (stronger units have higher chance)
			int i, j, k, gold, food;
			IntArray weights;//every index contains the value of the unit type, higher values have more indexes (higher chance to be chosen)
			for (i = 0; i < 6; i += 1)//check whether a specialization is already being researched
				if (i == 5) {
					if (IsResearching(set, "Forge shields"))
						return;
				}
				else if (IsResearching(set, UTech(i, Carthage)))
					return;
			for (i = 0; i < 6; i += 1) {
				if (i == 5)
					strTech = "Forge shields";
				else
					strTech = UTech(i, Carthage);
				if (set.CanResearch(strTech))
					if (set.CanAfford(strTech))
						for (j = 0; j <= i; j += 1) {
							weights[k] = i;
							k += 1;
						}
			}
			if (k == 0)//nothing is researchable/affordable
				return;
			nType = weights[rand(k)];
			if (nType == 5) {
				nType = 6;//6-CHorseman
				strTech = "Forge shields";
			}
			else
				strTech = UTech(nType, Carthage);
			GetCmdCost(strTech, gold, food);
			set.SpentGoldOnTech(gold + food / 2);
			set.Research(strTech);
			EnvWriteInt(set, "nSpecTime", GetTime() + 300000 + rand(300000));
			return;
		}
		else {//a unit is already specialized -> recruit it or, if 5-10 minutes have passed, stop specialization (weaker units have higher chance) and choose one in next execution
			if (EnvReadInt(set, "nSpecTime") <= 0)//this check is used to avoid a specialization change right after specific tactic scripts
				EnvWriteInt(set, "nSpecTime", GetTime() + 300000 + rand(300000));
			if (GetTime() >= EnvReadInt(set, "nSpecTime"))
				if (rand(nType + 1) > 0)
					EnvWriteInt(set, "nSpecTime", GetTime() + 300000 + rand(300000));
				else {
					set.Research("StopSpecialization");
					return;
				}
		}

		//if specialization is for ranged units (1-CJavelinThrower or 6-CHorseman) and there are too many of them, recruit 5-CNoble instead (only if possible)
		if (!bBuildMercArmy)
			if (nType == 1 || nType == 6)
				if (IsResearched(set, "Sacred Legion")) {
					int c;
					//myrmidons and ranged chariots are not counted because they are special units
					c = Count(AIPlayer, "GArcher");
					c += Count(AIPlayer, "RArcher") + Count(AIPlayer, "RVelit");
					c += Count(AIPlayer, "CJavelinThrower") + Count(AIPlayer, "CHorseman");
					c += Count(AIPlayer, "IArcher") + Count(AIPlayer, "ISlinger");
					c += Count(AIPlayer, "BBowman") + Count(AIPlayer, "BJavelineer");
					c += Count(AIPlayer, "EArcher") + Count(AIPlayer, "EAxetrower");
					c += Count(AIPlayer, "HToxotes") + Count(AIPlayer, "HPeltast");
					c += Count(AIPlayer, "TArcher") + Count(AIPlayer, "THuntress") + Count(AIPlayer, "TTeutonArcher");
					if (c > AIVar(AIPlayer, AIV_RangedPercent) * nMilUnits / 100)
						nType = 5;
				}

		EnvWriteInt(set, "nBuildType", nType);
		EnvWriteInt(set, "nBuildCount", 10);
	}
}