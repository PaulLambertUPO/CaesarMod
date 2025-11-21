//void, Settlement set

//called from ES_Stronghold, this script sets "nBuildType" and "nBuildCount" in the settlement environment (Germany)

int nAssUnderFire;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold

if (nAssUnderFire <= 0)
	if (set.food < 800)
		return;

if (set.population > GetConst("MinPopulation")) {
	int aiPlayer, nType, nLastResearched, nMilUnits;
	bool bBuildArmy;
	StrArray maxUnitsConsts, germanTechs;

	aiPlayer = set.player;

	maxUnitsConsts[0] = "";
	maxUnitsConsts[1] = "";
	maxUnitsConsts[2] = "MaxAxemen";
	maxUnitsConsts[3] = "MaxHuntresses";
	maxUnitsConsts[4] = "MaxTeutonRiders";
	maxUnitsConsts[5] = "MaxMacemen";

	germanTechs[0] = "";
	germanTechs[1] = "";
	germanTechs[2] = "Axe production";
	germanTechs[3] = "Javelin production";
	germanTechs[4] = "Horseshoe production";
	germanTechs[5] = "Mace production";

	nType = -1;

	nLastResearched = EnvReadInt(set, "nLastResearched");
	if (nLastResearched > 0) {//if higher than 0, minimum value is 3 (for 2-TAxeman)
		str classTech;
		nType = nLastResearched - 1;
		classTech = UType(nType, Germany);
		if (Count(aiPlayer, classTech) + EnvReadInt(aiPlayer, "QueuedBuild/" + classTech) >= EnvReadInt(aiPlayer, maxUnitsConsts[nType])) {//max limit for desired unit
			Building b;
			classTech = germanTechs[nType];
			b = set.FindResearchLab(classTech);
			if (b.IsValid)
				if (b.CmdCount(classTech) > 0)//already researching to increase max limit of desired unit
					return;
			nType = -1;//no research going -> reset army recruitment (it happens if the building is invalid/broken or a human player with shared control stops the research)
			nLastResearched = 0;
			EnvWriteInt(set, "nLastResearched", 0);
		}
	}

	nMilUnits = MilUnits(aiPlayer);

	//decide whether to build army at all
	if (nAssUnderFire > 0)//no check on FreezeArmyBuild because almost all Germany techs cost gold only
		bBuildArmy = true;
	else {
		int nArmyBuilds;
		nArmyBuilds = EnvReadInt(set, "nArmyBuilds");//set in ES_Stronghold
		if (nArmyBuilds <= 0)
			bBuildArmy = true;
		else {
			int pop_perc;
			if (nMilUnits <= 20)
				pop_perc = 40;
			else if (nArmyBuilds <= 10)
				pop_perc = 45;
			else
				pop_perc = 50;
			bBuildArmy = set.population >= set.max_population * pop_perc / 100;
		}
	}

	if (bBuildArmy) {
		if (nType < 0) {//check which units are desired in case nothing has already been decided previously
			int i = 2;
			if (set.food >= 5000)//if there is a lot of food, give higher chance to the heavy unit (5-TMaceman)
				i = 4;
			if (rand(i) == 0)
				nType = rand(6);
			else
				nType = 5;
			if (nType >= 2) {//check limits for advanced units
				str classTech;
				classTech = UType(nType, Germany);
				if (Count(aiPlayer, classTech) + EnvReadInt(aiPlayer, "QueuedBuild/" + classTech) >= EnvReadInt(aiPlayer, maxUnitsConsts[nType])) {//max limit for desired unit
					int j;
					classTech = germanTechs[nType];
					if (set.CanAfford(classTech)) {//choose something else if impossible to research
						int gold, food;
						if (GetCmdCost(classTech, gold, food)) {
							Building b;
							b = set.FindResearchLab(classTech);
							if (b.IsValid)
								if (!b.IsBroken) {
									if (b.CmdCount(classTech) < 1) {//research the desired unit tech (note that it is a train command)
										point ptDummy;
										Obj objDummy;
										set.SpentGoldOnTech(gold + food / 2);
										b.ExecCmd(classTech, ptDummy, objDummy, false);
									}
									if (b.CmdCount(classTech) > 0) {
										EnvWriteInt(set, "nLastResearched", nType + 1);//recruit this unit in the next script execution to avoid wasting the research gold
										return;
									}
								}
						}
					}
					nType = -1;
					for (i = 0; i < 5; i += 1) {//no research is going, choose another advanced unit randomly (max 5 attempts)
						j = rand(4) + 2;//2-5
						classTech = UType(j, Germany);
						if (Count(aiPlayer, classTech) + EnvReadInt(aiPlayer, "QueuedBuild/" + classTech) < EnvReadInt(aiPlayer, maxUnitsConsts[j])) {
							nType = j;
							break;
						}
					}
				}
			}
		}
		if (rand(15) == 0)//very small chance to change idea and recruit basic units
			nType = -1;
		if (nType < 0)//in case nothing has been chosen, recruit basic units (0-TSwordsman or 1-TArcher)
			nType = rand(2);

		EnvWriteInt(set, "nBuildType", nType);
		EnvWriteInt(set, "nBuildCount", 10);
		if (nType == nLastResearched - 1)
			EnvWriteInt(set, "nLastResearched", 0);
	}
}