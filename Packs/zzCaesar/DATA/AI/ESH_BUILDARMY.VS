//void, Settlement set

//called from ES_Stronghold, this script sets "nBuildType" and "nBuildCount" in the settlement environment

int nAssUnderFire;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold

if (nAssUnderFire <= 0)
	if (set.gold < 800)
		return;

if (set.population > GetConst("MinPopulation")) {
	int Greece, nRace, nType, nLastResearched, AIPlayer, nMilUnits;
	bool nRaceIsImperialRome = false, nRaceIsPunicRome = false, bBuildArmy;
	StrArray imperialOrPunicOrGreekOrGaulTechs, gaulImprovedTechs;
	str strTech;

	Greece = ImperialRome;
	nRace = set.GetCentralBuilding().race;

	if (nRace == RepublicanRome)
		if (IsResearched(set, "ChooseImperialRome"))
			nRaceIsImperialRome = true;
		else if (IsResearched(set, "ChoosePunicRome"))
			nRaceIsPunicRome = true;
		else
			imperialOrPunicOrGreekOrGaulTechs[1] = "Roman Archers";//this manages the final part about basic units if nothing has been chosen

	if (nRaceIsImperialRome) {
		imperialOrPunicOrGreekOrGaulTechs[0] = "";
		imperialOrPunicOrGreekOrGaulTechs[1] = "Roman Archers";
		imperialOrPunicOrGreekOrGaulTechs[2] = "Roman Velit";
		imperialOrPunicOrGreekOrGaulTechs[3] = "Roman Principle";
		imperialOrPunicOrGreekOrGaulTechs[4] = "Roman Scout";
		imperialOrPunicOrGreekOrGaulTechs[5] = "Roman Praetorian";
	}
	else if (nRaceIsPunicRome) {
		imperialOrPunicOrGreekOrGaulTechs[0] = "";
		imperialOrPunicOrGreekOrGaulTechs[1] = "Roman Archers";
		imperialOrPunicOrGreekOrGaulTechs[2] = "Gladiator Shows";
		imperialOrPunicOrGreekOrGaulTechs[3] = "Roman Principle";
		imperialOrPunicOrGreekOrGaulTechs[4] = "Roman Scout";
		imperialOrPunicOrGreekOrGaulTechs[5] = "Roman Praetorian";
	}
	else if (nRace == Greece) {
		imperialOrPunicOrGreekOrGaulTechs[0] = "";
		imperialOrPunicOrGreekOrGaulTechs[1] = "Greek Archers";
		imperialOrPunicOrGreekOrGaulTechs[2] = "Greek Spears";
		imperialOrPunicOrGreekOrGaulTechs[3] = "Greek Horse Armor";
		imperialOrPunicOrGreekOrGaulTechs[4] = "Greek Royal Armor";
		imperialOrPunicOrGreekOrGaulTechs[5] = "Greek Chariot Wheels";
	}
	else if (nRace == Gaul) {//using the original function UTech is not correct because it returns the level 2 research, which messes up checks on IsResearching/IsResearched
		imperialOrPunicOrGreekOrGaulTechs[0] = "";
		imperialOrPunicOrGreekOrGaulTechs[1] = "";
		imperialOrPunicOrGreekOrGaulTechs[2] = "Gaul Axeman";
		imperialOrPunicOrGreekOrGaulTechs[3] = "Gaul Spearman";
		imperialOrPunicOrGreekOrGaulTechs[4] = "Gaul Horseman";
		imperialOrPunicOrGreekOrGaulTechs[5] = "Gaul Woman Warrior";

		gaulImprovedTechs[0] = "";
		gaulImprovedTechs[1] = "";
		gaulImprovedTechs[2] = "Gaul Iron Axes";
		gaulImprovedTechs[3] = "Gaul Iron Spearheads";
		gaulImprovedTechs[4] = "Gaul Exceptional Horseshoes";
		gaulImprovedTechs[5] = "Gaul Fine Armor";
	}

	nType = -1;

	nLastResearched = EnvReadInt(set, "nLastResearched");
	if (nLastResearched > 0) {
		nType = nLastResearched - 1;
		if (nRaceIsImperialRome) {
			strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
			if (nType == 5)
				if (IsResearched(set, strTech))
					strTech = "Improve Praetorian Equipment";
		}
		else if (nRaceIsPunicRome)
			strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
		else if (nRace == Greece)
			strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
		else if (nRace == Gaul) {
			strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
			if (IsResearched(set, strTech))
				strTech = gaulImprovedTechs[nType];
		}
		else
			strTech = UTech(nType, nRace);
		if (IsResearching(set, strTech))//already researching for desired unit
			return;
		if (!IsResearched(set, strTech)) {//no research going -> reset army recruitment (it might happen because a human player with shared control stopped the research)
			nType = -1;
			nLastResearched = 0;
			EnvWriteInt(set, "nLastResearched", 0);
			EnvWriteInt(set, "nLastResearchedCounter", 0);
		}
	}

	AIPlayer = set.player;
	nMilUnits = MilUnits(AIPlayer);

	//decide whether to build army at all
	if (nAssUnderFire > 0)
		bBuildArmy = true;
	else if (EnvReadInt(set, "FreezeArmyBuild") > 0)
		bBuildArmy = false;
	else {
		int nArmyBuilds;
		nArmyBuilds = EnvReadInt(set, "nArmyBuilds");//set in ES_Stronghold
		if (nArmyBuilds <= 0)
			bBuildArmy = true;
		else {
			int pop_perc;
			if (nMilUnits <= 20)
				pop_perc = 30;
			else if (nArmyBuilds <= 10)
				pop_perc = 35;
			else
				pop_perc = 40;
			bBuildArmy = set.population >= set.max_population * pop_perc / 100;
		}
	}
	if (bBuildArmy) {
		int i, nCount = 10;
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
			int nDesireCount, j, k, r = 2;
			for (i = 5; i >= 0; i -= 1) {
				if (bTooManyRanged)
					if (i == 1)//GArcher, RArcher(Punic), IArcher, BBowman, EArcher, HToxotes
						continue;
					else if (i == 4) {//ISlinger or BJavelineer
						if (nRace == Iberia)
							continue;
						if (nRace == Britain)
							continue;
					}
					else if (i == 2) {//RVelit or EAxetrower
						if (nRaceIsImperialRome)
							continue;
						if (nRace == Egypt)
							continue;
					}
					else if (i == 0)//HPeltast
						if (nRace == Greece)
							continue;
				if (bNeedRanged)
					if (i == 4) {
						if (nRace != Iberia)
							if (nRace != Britain)
								continue;
					}
					else if (i == 2) {
						if (!nRaceIsImperialRome)
							if (nRace != Egypt)
								continue;
					}
					else if (i == 0)
						if (nRace != Greece)
							continue;
				desiredUnits[nDesireCount] = i;//possible outcomes are [5, 4, 3, 2, 1, 0] or its subsets with only or without ranged unit numbers, depending on the race
				nDesireCount += 1;
			}
			if (set.gold >= 5000)//if there is a lot of gold, give higher chance to the heavy unit (5 - RTribune, RPraetorian(Punic), HChariot, GWomanWarrior, EGuardian, IEliteGuard, BHighlander)
				r = 5;
			if (rand(r) == 0)//shuffle desired units
				for (i = 0; i < nDesireCount - 1; i += 1) {
					j = rand(i + 1);
					k = desiredUnits[i];
					desiredUnits[i] = desiredUnits[j];
					desiredUnits[j] = k;
				}
			nType = desiredUnits[0];
			if (nType == 5)
				if (rand(2) == 0)//5-HChariot and 5-EGuardian have a 50% chance to be replaced by 4-HHypaspista or 3-EAnubisWarrior/4-EHorusWarrior
					if (nRace == Greece)
						nType = 4;
					else if (nRace == Egypt)
						nType = rand(2) + 3;

			if (nRaceIsImperialRome) {
				strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
				if (nType == 5)
					if (rand(2) == 0)
						if (IsResearched(set, strTech))
							strTech = "Improve Praetorian Equipment";
			}
			else if (nRaceIsPunicRome)
				strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
			else if (nRace == Greece)
				strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
			else if (nRace == Gaul) {
				strTech = imperialOrPunicOrGreekOrGaulTechs[nType];
				if (strTech != "")
					if (rand(2) == 0)
						if (IsResearched(set, strTech))
							strTech = gaulImprovedTechs[nType];
			}
			else
				strTech = UTech(nType, nRace);

			if (strTech != "")
				if (!IsResearched(set, strTech)) {
					int nArmyTechTime;
					nArmyTechTime = EnvReadInt(set, "nArmyTechTime");
					if (nArmyTechTime <= 0) {//this is to avoid a research right after specific tactic scripts (wait at least 2-4 minutes)
						nArmyTechTime = GetTime() + 120000 + rand(120000);
						EnvWriteInt(set, "nArmyTechTime", nArmyTechTime);
					}
					if (GetTime() >= nArmyTechTime) {
						bool startedResearch = false;
						if (set.CanResearch(strTech))
							if (set.CanAfford(strTech)) {//using ESH_NeedTech is not good because it might set FreezeArmyBuild
								int gold, food;
								if (GetCmdCost(strTech, gold, food)) {
									set.SpentGoldOnTech(gold + food / 2);
									set.Research(strTech);
									startedResearch = true;
								}
							}
						if (startedResearch) {//IsResearching does not seem to work (and using Sleep causes a crash)
							int c;//recruit at least 25-40 units (8-12 in case of 5-HChariot) of the researched type before switching to another one
							if (nRace == Greece && nType == 5)
								c = rand(5) + 8;
							else
								c = rand(16) + 25;
							EnvWriteInt(set, "nLastResearched", nType + 1);
							EnvWriteInt(set, "nLastResearchedCounter", c);
							EnvWriteInt(set, "nArmyTechTime", GetTime() + 120000 + rand(120000));
							return;
						}
					}
					nType = -1;
					if (nRace == RepublicanRome) {
						k = 1;
						r = 5;
					}
					else if (nRace == Greece) {
						k = 1;
						r = 5;
					}
					else if (nRace == Egypt) {
						k = 3;
						r = 2;
					}
					else {
						k = 2;
						r = 4;
					}
					for (i = 0; i < 5 && nType < 0; i += 1) {//no research is going, choose another advanced unit randomly (max 5 attempts)
						j = rand(r) + k;//1-5 or 3-4 or 2-5, depending on the race
						if (bTooManyRanged)
							if (j == 1) {//RArcher(Punic) or HToxotes
								if (nRace == RepublicanRome)
									continue;
								if (nRace == Greece)
									continue;
							}
							else if (j == 2) {//RVelit or EAxetrower
								if (nRaceIsImperialRome)
									continue;
								if (nRace == Egypt)
									continue;
							}
							else if (j == 4) {//ISlinger or BJavelineer
								if (nRace == Iberia)
									continue;
								if (nRace == Britain)
									continue;
							}
						if (nRaceIsImperialRome) {
							strTech = imperialOrPunicOrGreekOrGaulTechs[j];
							if (j == 5)
								if (rand(2) == 0)
									strTech = "Improve Praetorian Equipment";
						}
						else if (nRaceIsPunicRome)
							strTech = imperialOrPunicOrGreekOrGaulTechs[j];
						else if (nRace == Greece) {
							if (j == 5)
								if (rand(2) == 0)//5-HChariot has a 50% chance to be replaced by 4-HHypaspista
									j = 4;
							strTech = imperialOrPunicOrGreekOrGaulTechs[j];
						}
						else if (nRace == Gaul) {
							strTech = imperialOrPunicOrGreekOrGaulTechs[j];
							if (rand(2) == 0)
								strTech = gaulImprovedTechs[j];
						}
						else
							strTech = UTech(j, nRace);
						if (IsResearched(set, strTech))//note that units with 2 researches have reduced chance to be chosen if only the first has been completed
							nType = j;
					}
				}
		}
		if (rand(10) == 0)//very small chance to change idea and recruit basic units
			nType = -1;
		if (nType < 0) {//in case nothing has been chosen, recruit basic units
			nType = 0;
			if (bNeedRanged)
				if (nRace == RepublicanRome) {
					if (IsResearched(set, imperialOrPunicOrGreekOrGaulTechs[1]))
						nType = 1;
				}
				else if (nRace == Greece) {
					if (IsResearched(set, imperialOrPunicOrGreekOrGaulTechs[1]))
						nType = 1;
				}
				else
					nType = 1;
		}

		EnvWriteInt(set, "nBuildType", nType);
		if (nRace == Greece)
			if (nType == 5)//in case of 5-HChariot, reduce the amount of units to recruit (4-6 instead of 10) because the cost is very high and they are not attachable to heroes
				nCount = rand(3) + 4;

		if (nType == nLastResearched - 1) {
			int nLastResearchedCounter;
			nLastResearchedCounter = EnvReadInt(set, "nLastResearchedCounter");
			nLastResearchedCounter -= MIN(nCount, nLastResearchedCounter);
			EnvWriteInt(set, "nLastResearchedCounter", nLastResearchedCounter);
			if (nLastResearchedCounter <= 0)
				EnvWriteInt(set, "nLastResearched", 0);
		}
		EnvWriteInt(set, "nBuildCount", nCount);
	}
}