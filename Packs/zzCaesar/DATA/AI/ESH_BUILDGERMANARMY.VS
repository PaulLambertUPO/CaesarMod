//void, Settlement set

//called from ES_Stronghold, this script sets "nBuildType" and "nBuildCount" in the settlement environment

int nAssUnderFire;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold

if (nAssUnderFire <= 0)
	if (set.food < 800)
		return;

if (set.population > GetConst("MinPopulation")) {
	int AIPlayer, nType, nLastResearched, nMilUnits;
	bool bBuildArmy;
	StrArray maxUnitsConsts, germanTechs;

	AIPlayer = set.player;

	maxUnitsConsts[0] = "";
	maxUnitsConsts[1] = "";
	maxUnitsConsts[2] = "MaxAxemen";
	maxUnitsConsts[3] = "MaxHuntresses";
	maxUnitsConsts[4] = "MaxTeutonRiders";
	maxUnitsConsts[5] = "MaxMacemen";

	germanTechs[0] = "";
	germanTechs[1] = "";
	germanTechs[2] = "Axemen production";
	germanTechs[3] = "Javelin production";
	germanTechs[4] = "Horseshoes production";
	germanTechs[5] = "Macemen production";

	nType = -1;

	nLastResearched = EnvReadInt(set, "nLastResearched");
	if (nLastResearched > 0) {//if higher than 0, minimum value is 3 (for 2-TAxeman)
		nType = nLastResearched - 1;
		if (Count(AIPlayer, UType(nType, Germany)) >= EnvReadInt(AIPlayer, maxUnitsConsts[nType])) {//tech needed (max limit for desired unit has been reached)
			Building b;
			b = set.FindResearchLab(germanTechs[nType]);
			if (b.IsValid)
				if (b.CmdCount(germanTechs[nType]) > 0)//already researching to increase max limit of desired unit
					return;
			nType = -1;//no research going -> reset army recruitment (it might happen because a human player with shared control stopped the research)
			nLastResearched = 0;
			EnvWriteInt(set, "nLastResearched", 0);
		}
	}

	nMilUnits = MilUnits(AIPlayer);

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
		int i;
		bool bTooManyRanged, bNeedRanged = false;
		IntArray desiredUnits;

		//myrmidons and ranged chariots are not counted because they are special units
		i = Count(AIPlayer, "GArcher");
		i += Count(AIPlayer, "RArcher") + Count(AIPlayer, "RVelit");
		i += Count(AIPlayer, "CJavelinThrower") + Count(AIPlayer, "CHorseman");
		i += Count(AIPlayer, "IArcher") + Count(AIPlayer, "ISlinger");
		i += Count(AIPlayer, "BBowman") + Count(AIPlayer, "BJavelineer");
		i += Count(AIPlayer, "EArcher") + Count(AIPlayer, "EAxetrower");
		i += Count(AIPlayer, "HToxotes") + Count(AIPlayer, "HPeltast");
		i += Count(AIPlayer, "TArcher") + Count(AIPlayer, "THuntress") + Count(AIPlayer, "TTeutonArcher");

		bTooManyRanged = i > AIVar(AIPlayer, AIV_RangedPercent) * nMilUnits / 100;
		if (!bTooManyRanged)
			if (nMilUnits >= 15)
				if (i < AIVar(AIPlayer, AIV_RangedPercent) * nMilUnits / 200)
					bNeedRanged = true;//needed when less than half of the percentage (at least 15 units)

		if (nType < 0) {//check which units are desired in case nothing has already been decided previously
			int nDesireCount, j, r = 2;
			for (i = 5; i >= 0; i -= 1) {
				if (bTooManyRanged)
					if (i == 1)//TArcher
						continue;
					else if (i == 3)//THuntress
						continue;
				if (bNeedRanged)
					if (i != 1)
						if (i != 3)
							continue;
				desiredUnits[nDesireCount] = i;//possible outcomes are [5, 4, 3, 2, 1, 0], [5, 4, 2, 0] or [3, 1]
				nDesireCount += 1;
			}
			if (set.food >= 5000)//if there is a lot of food, give higher chance to the heavy unit (5-TMaceman)
				r = 5;
			if (rand(r) == 0)//shuffle desired units
				for (i = 0; i < nDesireCount - 1; i += 1) {
					j = rand(i + 1);
					r = desiredUnits[i];
					desiredUnits[i] = desiredUnits[j];
					desiredUnits[j] = r;
				}
			nType = desiredUnits[0];
			if (nType >= 2)//check limits for advanced units
				if (Count(AIPlayer, UType(nType, Germany)) >= EnvReadInt(AIPlayer, maxUnitsConsts[nType])) {//tech needed (max limit for desired unit has been reached)
					str cmd;
					int gold, food;
					cmd = germanTechs[nType];
					if (GetCmdCost(cmd, gold, food))
						if (set.CanAfford(cmd)) {//choose something else if impossible to research
							Building b;
							b = set.FindResearchLab(cmd);
							if (b.IsValid) {
								if (b.CmdCount(cmd) < 1) {//research the desired unit tech (note that it is a train command)
									point ptDummy;
									Obj objDummy;
									set.SpentGoldOnTech(gold + food / 2);
									b.ExecCmd(cmd, ptDummy, objDummy, false);
								}
								if (b.CmdCount(cmd) > 0) {
									EnvWriteInt(set, "nLastResearched", nType + 1);//recruit this unit in next script execution in order to avoid wasting the research gold
									return;
								}
							}
						}
					nType = -1;
					for (i = 0; i < 5 && nType < 0; i += 1) {//in case the desired unit has reached max limit and no research is going, choose another advanced one randomly (max 5 attempts)
						j = rand(4) + 2;//2-5
						if (bTooManyRanged)
							if (j == 3)//THuntress
								continue;
						if (Count(AIPlayer, UType(j, Germany)) < EnvReadInt(AIPlayer, maxUnitsConsts[j]))
							nType = j;
					}
				}
		}
		if (rand(10) == 0)//very small chance to change idea and recruit basic units
			nType = -1;
		if (nType < 0)//in case nothing has been chosen, recruit basic units (0-TSwordsman or 1-TArcher)
			if (bNeedRanged)
				nType = 1;
			else
				nType = 0;

		EnvWriteInt(set, "nBuildType", nType);
		EnvWriteInt(set, "nBuildCount", 10);
		if (nType == nLastResearched - 1)
			EnvWriteInt(set, "nLastResearched", 0);
	}
}