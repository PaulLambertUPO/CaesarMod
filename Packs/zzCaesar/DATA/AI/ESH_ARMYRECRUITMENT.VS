//void, Settlement set

//called by ES_Stronghold, this script manages the desperate defence of the stronghold, the recruitment of heroes and the recruitment of units

int Greece, AIPlayer, nRace, min_pop;
int i, gold, food, nUnattachedMilUnitsAtHome, nHeroes;
SquadList sl;
Squad squad;
Hero h;
StrArray imperialOrPunicOrGreekTrainCmds;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false, bDesperateDefence = true, bHireHero = true;
str cmd;
point ptDummy;
Obj objDummy;

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else if (IsResearched(set, "ChoosePunicRome"))
		nRaceIsPunicRome = true;

if (nRaceIsImperialRome) {
	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatus";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcher";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRVelit";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciple";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScout";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianBase";
}
else if (nRaceIsPunicRome) {
	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatusPunic";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcherPunic";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRGladiatorPunic";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciplePunic";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScoutPunic";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianPunic";
}
else if (nRace == Greece) {
	imperialOrPunicOrGreekTrainCmds[0] = "trainHPeltast";
	imperialOrPunicOrGreekTrainCmds[1] = "trainHToxotes";
	imperialOrPunicOrGreekTrainCmds[2] = "trainHHoplite";
	imperialOrPunicOrGreekTrainCmds[3] = "trainHCataphract";
	imperialOrPunicOrGreekTrainCmds[4] = "trainHHypaspista";
	imperialOrPunicOrGreekTrainCmds[5] = "trainHChariot";
}

//desperate defence - spam a huge amount of basic units if there are enemy units near the townhall
if (nRace == Germany) {
	if (set.food < 400)
		bDesperateDefence = false;
	else if (set.population <= GetConst("MinPopulation"))
		bDesperateDefence = false;
}
else if (set.gold < 400)
	bDesperateDefence = false;
else if (nRace != Carthage)
	if (set.population <= GetConst("MinPopulation"))
		bDesperateDefence = false;
	else if (nRace == Iberia)
		if (set.CanAfford("Call to arms"))
			bDesperateDefence = false;
if (bDesperateDefence)
	if (!Intersect(ObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(AIPlayer, "Military")).IsEmpty()) {
		if (nRaceIsImperialRome)
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRaceIsPunicRome)
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRace == Greece)
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRace == Carthage) {
			cmd = UTrainCmd(0, Carthage) + "NonSpec";//CLibyanFootman
			if (EnvReadString(set, "Specialization") != "") {
				i = EnvReadInt(set, "SpecializedUnit") - 1;//0-4 or 6 (5 is for CNoble in the temple)
				if (i == 1)
					cmd = UTrainCmd(1, Carthage);//CJavelinThrower
				else if (i == 0)
					cmd = UTrainCmd(0, Carthage);//CLibyanFootman
			}
		}
		else
			cmd = UTrainCmd(0, nRace);
		if (GetCmdCost(cmd, gold, food)) {
			Barrack barrack;
			if (nRace == Greece) {
				ObjList buildings;
				int j, min;
				bool first_time = true;
				buildings = set.Buildings();
				for (j = 0; j < buildings.count; j += 1)
					if (buildings[j].class == "HBarracks")
						if (first_time || buildings[j].CmdCount < min) {
							first_time = false;
							min = buildings[j].CmdCount;
							barrack = buildings[j];
						}
			}
			else
				barrack = set.BestBarrack(100);
			if (barrack.IsValid) {
				i = MIN(30, set.MaxAffordCount(cmd));
				if (i > 0) {
					int j;
					set.SpentGoldOnArmy((gold + food / 2) * i);
					for (j = 0; j < i; j += 1)
						barrack.ExecCmd(cmd, ptDummy, objDummy, false);
				}
			}
		}
	}

//hero support
set.GetGaika().GetSquads(sl, AI_STAYING + AI_COMING, AIPlayer, AI_OWN);
while (!sl.EOL) {
	squad = sl.Cur;
	if (!squad.TestFlags(SF_PEACEFUL + SF_NOAI))
		if (!squad.Leader.GetFlags(UNITFLAG_NOAI)) {
			h = squad.Leader.AsHero();
			if (h.IsValid) {
				nHeroes += 1;
				if (h.army.count < h.maxarmy / 2)
					if (rand(3) == 0)
						bHireHero = false;
			}
			else if (!squad.Leader.HasFreedom())
				nUnattachedMilUnitsAtHome += squad.Size;
		}
	sl.Next;
}
if (nHeroes >= 1)
	if (nUnattachedMilUnitsAtHome < 6)
		bHireHero = false;
	else if (HeroArmiesFullPerc(set.player) < 60)
		bHireHero = false;
if (bHireHero) {
	if (nRaceIsImperialRome)
		cmd = "hireheroRImperial";
	else if (nRaceIsPunicRome)
		cmd = "hireheroRPunic";
	else if (nRace == Greece)
		cmd = "hireheroH";
	else
		cmd = "hirehero" + GetRaceStrPref(nRace);
	if (GetCmdCost(cmd, gold, food))
		if (set.CanResearch(cmd))
			if (set.CanAfford(cmd)) {
				set.SpentGoldOnArmy(gold + food / 2);
				set.Research(cmd);
				bHireHero = false;
			}
}

//build army in barracks
if (EnvReadInt(set, "AssUnderFire") > 0 || !bHireHero && EnvReadInt(set, "FreezeArmyBuild") == 0) {
	Barrack barrack;
	int nBuildType, nCount;

	nBuildType = EnvReadInt(set, "nBuildType");
	nCount = EnvReadInt(set, "nBuildCount");

	if (nRace == Greece) {
		ObjList buildings;
		int j, min;
		bool first_time = true;
		buildings = set.Buildings();
		for (j = 0; j < buildings.count; j += 1)
			if (buildings[j].class == "HBarracks")
				if (first_time || buildings[j].CmdCount < min) {
					first_time = false;
					min = buildings[j].CmdCount;
					barrack = buildings[j];
				}
	}
	else {
		barrack = set.BestBarrack(10);
		if (nRace == Carthage)
			if (nCount > 0)
				if (nBuildType == 5)//CNoble management (in "The Punic Wars" they were recruited in the barracks)
					barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
	}

	if (barrack.IsValid)
		if (barrack.CmdCount < 10) {//available barrack
			if (nCount <= 0)
				if (barrack.command == "idle") {//ask for new units to build
					if (nRace == Germany)
						set.AIRun("ESH_BuildGermanArmy.vs");
					else if (nRace == Carthage)
						set.AIRun("ESH_BuildCarthaginianArmy.vs");
					else
						set.AIRun("ESH_BuildArmy.vs");

					nBuildType = EnvReadInt(set, "nBuildType");
					nCount = EnvReadInt(set, "nBuildCount");

					if (nCount > 0) {
						EnvWriteInt(set, "nArmyBuilds", MIN(1 + EnvReadInt(set, "nArmyBuilds"), 11));//11 is to avoid possible overflow and because managed max value is 10
						if (nRace == Carthage)
							if (nBuildType == 5)
								barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
					}
				}
			if (nCount > 0)
				if (barrack.IsValid)//check validity again because of Carthage case above
					if (barrack.command == "idle") {
						if (nRaceIsImperialRome)
							if (nBuildType == 5 && IsResearched(set, "Improve Praetorian Equipment"))
								cmd = "trainRPraetorianDiscounted";
							else
								cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
						else if (nRaceIsPunicRome)
							cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
						else if (nRace == Greece)
							cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
						else if (nRace == Carthage && nBuildType == 6)
							cmd = "trainCHorseman";
						else
							cmd = UTrainCmd(nBuildType, nRace);

						//wait for a research to finish in order to optimize useful upgrades for many troops
						if (nCount > 0)
							if (nRace == Carthage) {
								if (nBuildType < 5) {
									if (IsResearching(set, UTech(nBuildType, nRace)))
										nCount = 0;
								}
								else if (nBuildType == 6)
									if (IsResearching(set, "Forge shields"))
										nCount = 0;
							}
							else if (nRaceIsImperialRome) {
								if (IsResearching(AIPlayer, "Flexibility"))
									nCount = 0;
								else if (nBuildType == 5)
									if (IsResearching(set, "Improve Praetorian Equipment"))
										nCount = 0;
							}
							else if (nRace == Britain) {
								if (nBuildType == 5)
									if (IsResearching(set, "Steel Weapons"))
										nCount = 0;
							}
							else if (nRace == Gaul)
								if (IsResearching(set, "Nordic trade routes"))
									nCount = 0;
								else if (IsResearching(set, "Belts of Might"))
									nCount = 0;
								else if (IsResearching(set, "Herb amulets"))
									nCount = 0;

						if (nRace == Carthage)
							if (nBuildType < 5) {
								if (!IsResearched(set, UTech(nBuildType, nRace)))
									cmd = cmd + "NonSpec";
							}
							else if (nBuildType == 6)
								if (!IsResearched(set, "Forge shields"))
									cmd = cmd + "NonSpec";

						if (GetCmdCost(cmd, gold, food)) {
							i = MIN(10, MIN(set.MaxAffordCount(cmd), nCount));
							if (i > 0) {
								int j;
								nCount -= i;
								EnvWriteInt(set, "nBuildCount", nCount);
								set.SpentGoldOnArmy((gold + food / 2) * i);
								for (j = 0; j < i; j += 1)
									barrack.ExecCmd(cmd, ptDummy, objDummy, false);
							}
						}
					}
		}
}