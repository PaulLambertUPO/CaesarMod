//void, Settlement set, str class, int num, ObjList ol

//called by specific tactic scripts (TS_...Tactic), this script manages the recruitment of standard units (barracks)

ObjList ol1, ol2;
Unit u;
int Greece, nRace, nBuildType, i;
str cmd, tech;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;
StrArray imperialOrPunicOrGreekClasses, imperialOrPunicOrGreekTrainCmds, imperialOrPunicOrGreekTechs;

Greece = ImperialRome;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else if (IsResearched(set, "ChoosePunicRome"))
		nRaceIsPunicRome = true;

if (nRaceIsImperialRome) {
	imperialOrPunicOrGreekClasses[0] = "RHastatus";
	imperialOrPunicOrGreekClasses[1] = "RArcher";
	imperialOrPunicOrGreekClasses[2] = "RVelit";
	imperialOrPunicOrGreekClasses[3] = "RPrinciple";
	imperialOrPunicOrGreekClasses[4] = "RScout";
	imperialOrPunicOrGreekClasses[5] = "RPraetorian";
	imperialOrPunicOrGreekClasses[6] = "RPraetorian";

	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatus";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcher";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRVelit";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciple";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScout";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianBase";
	imperialOrPunicOrGreekTrainCmds[6] = "trainRPraetorianDiscounted";

	imperialOrPunicOrGreekTechs[0] = "";
	imperialOrPunicOrGreekTechs[1] = "Roman Archers";
	imperialOrPunicOrGreekTechs[2] = "Roman Velit";
	imperialOrPunicOrGreekTechs[3] = "Roman Principle";
	imperialOrPunicOrGreekTechs[4] = "Roman Scout";
	imperialOrPunicOrGreekTechs[5] = "Roman Praetorian";
	imperialOrPunicOrGreekTechs[6] = "Improve Praetorian Equipment";
}
else if (nRaceIsPunicRome) {
	imperialOrPunicOrGreekClasses[0] = "RHastatusPunic";
	imperialOrPunicOrGreekClasses[1] = "RArcherPunic";
	imperialOrPunicOrGreekClasses[2] = "RGladiatorPunic";
	imperialOrPunicOrGreekClasses[3] = "RPrinciplePunic";
	imperialOrPunicOrGreekClasses[4] = "RScoutPunic";
	imperialOrPunicOrGreekClasses[5] = "RPraetorianPunic";

	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatusPunic";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcherPunic";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRGladiatorPunic";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciplePunic";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScoutPunic";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianPunic";

	imperialOrPunicOrGreekTechs[0] = "";
	imperialOrPunicOrGreekTechs[1] = "Roman Archers";
	imperialOrPunicOrGreekTechs[2] = "Gladiator Shows";
	imperialOrPunicOrGreekTechs[3] = "Roman Principle";
	imperialOrPunicOrGreekTechs[4] = "Roman Scout";
	imperialOrPunicOrGreekTechs[5] = "Roman Praetorian";
}
else if (nRace == Greece) {
	imperialOrPunicOrGreekClasses[0] = "HPeltast";
	imperialOrPunicOrGreekClasses[1] = "HToxotes";
	imperialOrPunicOrGreekClasses[2] = "HHoplite";
	imperialOrPunicOrGreekClasses[3] = "HCataphract";
	imperialOrPunicOrGreekClasses[4] = "HHypaspista";
	imperialOrPunicOrGreekClasses[5] = "HChariot";

	imperialOrPunicOrGreekTrainCmds[0] = "trainHPeltast";
	imperialOrPunicOrGreekTrainCmds[1] = "trainHToxotes";
	imperialOrPunicOrGreekTrainCmds[2] = "trainHHoplite";
	imperialOrPunicOrGreekTrainCmds[3] = "trainHCataphract";
	imperialOrPunicOrGreekTrainCmds[4] = "trainHHypaspista";
	imperialOrPunicOrGreekTrainCmds[5] = "trainHChariot";

	imperialOrPunicOrGreekTechs[0] = "";
	imperialOrPunicOrGreekTechs[1] = "Greek Archers";
	imperialOrPunicOrGreekTechs[2] = "Greek Spears";
	imperialOrPunicOrGreekTechs[3] = "Greek Horse Armor";
	imperialOrPunicOrGreekTechs[4] = "Greek Royal Armor";
	imperialOrPunicOrGreekTechs[5] = "Greek Chariot Wheels";
}

if (nRaceIsImperialRome)
	for (i = 0; i < 7; i += 1) {
		if (imperialOrPunicOrGreekClasses[i] == class) {
			nBuildType = i;
			break;
		}
	}
else if (nRaceIsPunicRome)
	for (i = 0; i < 6; i += 1) {
		if (imperialOrPunicOrGreekClasses[i] == class) {
			nBuildType = i;
			break;
		}
	}
else if (nRace == Greece)
	for (i = 0; i < 6; i += 1) {
		if (imperialOrPunicOrGreekClasses[i] == class) {
			nBuildType = i;
			break;
		}
	}
else
	nBuildType = RUType(class, nRace);

if (nRaceIsImperialRome) {
	cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
	tech = imperialOrPunicOrGreekTechs[nBuildType];
}
else if (nRaceIsPunicRome) {
	cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
	tech = imperialOrPunicOrGreekTechs[nBuildType];
}
else if (nRace == Greece) {
	cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
	tech = imperialOrPunicOrGreekTechs[nBuildType];
}
else {
	cmd = UTrainCmd(nBuildType, nRace);
	tech = UTech(nBuildType, nRace);
}

if (num) {//steal from the AI
	ol1 = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits(class, set.player, num, false);
	for (i = 0; i < ol1.count; i += 1) {
		u = ol1[i].AsUnit();
		if (u.IsAlive) {
			if (u.hero.IsValid)
				u.DetachFrom(u.hero);
			ol2.Add(u);
		}
	}
	num -= ol2.count;
}

if (num) {//count how many are queued
	ObjList barracks;
	if (nRace == Greece) {
		ObjList buildings;
		buildings = set.Buildings();
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HBarracks")
				barracks.Add(buildings[i]);
	}
	else
		barracks = set.TSGetAllBarracks();
	for (i = 0; i < barracks.count; i += 1)
		num -= barracks[i].CmdCount(cmd);
}

//issue commands
if (tech != "")
	if (IsResearched(set, tech))
		tech = "";

if (tech == "") {
	Barrack barrack;
	int gold, food;
	point ptDummy;
	Obj objDummy;
	for (i = 0; i < num; i += 1) {
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
		else if (nRace == Carthage && nBuildType == 5)//CNoble
			barrack = set.FindResearchLab(cmd);
		else
			barrack = set.BestBarrack(100);

		if (barrack.IsValid) {
			if (nRace == Carthage)
				if (!IsResearched(set, UTech(nBuildType, nRace)))
					cmd = cmd + "NonSpec";
			if (GetCmdCost(cmd, gold, food)) {
				if (set.gold < gold)
					break;
				if (set.food < food)
					break;
				set.SpentGoldOnArmy(gold + food / 2);
				barrack.ExecCmd(cmd, ptDummy, objDummy, false);
			}
		}
	}
}

SetNoAIFlag(ol2, true);
ol.AddList(ol2);