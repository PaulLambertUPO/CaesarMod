//void, Settlement set, int num, ObjList ol

//called by specific tactic scripts (TS_...Tactic), this script manages the recruitment of special units (arena)

ObjList ol1, ol2;
int Greece, nRace, i, nUnitsPerCommand = 1;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;
str cmd, tech, class;

Greece = ImperialRome;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else if (IsResearched(set, "ChoosePunicRome"))
		nRaceIsPunicRome = true;

if (nRaceIsImperialRome) {
	cmd = "Hire Liberati";
	tech = "Gladiator Shows";
	class = "RLiberatus";
}
else if (nRaceIsPunicRome) {
	cmd = "Hire Liberati Punic";
	tech = "Gladiator Shows";
	class = "RLiberatus";//do not use RLiberatusPunic otherwise GetAIControlledUnits below might give a wrong result
}
else if (nRace == Greece) {
	cmd = "trainHMyrmidon";
	tech = "Olympic Games";
	class = "HMyrmidon_Javelin";
}
else {
	cmd = ArenaTrainCmd(nRace);
	tech = ArenaUTech(nRace);
	class = ArenaUType(nRace);
}

if (nRaceIsImperialRome)
	nUnitsPerCommand = 10;
else if (nRaceIsPunicRome)
	nUnitsPerCommand = 10;
else if (nRace == Germany)
	nUnitsPerCommand = 5;

if (num) {//steal from the AI
	Unit u;
	ol1 = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits(class, set.player, num, false);
	for (i = 0; i < ol1.count; i += 1) {
		u = ol1[i].AsUnit;
		if (u.IsAlive) {
			if (u.hero.IsValid)
				u.DetachFrom(u.hero);
			ol2.Add(u);
		}
	}
	num -= ol2.count;
}

if (num) {//count how many are queued
	ObjList arenae;
	if (nRace == Greece) {
		ObjList buildings;
		buildings = set.Buildings();
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HGymnasium")
				arenae.Add(buildings[i]);
	}
	else
		arenae = set.TSGetAllArenae();
	for (i = 0; i < arenae.count; i += 1)
		num -= arenae[i].CmdCount(cmd) * nUnitsPerCommand;
}

if (tech != "" && IsResearched(set, tech)) {//issue commands
	Building b;
	int gold, food;
	point ptDummy;
	Obj objDummy;
	num = (num + nUnitsPerCommand - 1) / nUnitsPerCommand;
	for (i = 0; i < num; i += 1) {
		if (nRace == Greece) {
			ObjList buildings;
			int j, min;
			bool first_time = true;
			buildings = set.Buildings();
			for (j = 0; j < buildings.count; j += 1)
				if (buildings[j].class == "HGymnasium")
					if (first_time || buildings[j].CmdCount < min) {
						first_time = false;
						min = buildings[j].CmdCount;
						b = buildings[j];
					}
		}
		else
			b = set.BestArena();
		if (b.IsValid)
			if (GetCmdCost(cmd, gold, food)) {
				if (set.gold < gold)
					break;
				if (set.food < food)
					break;
				set.SpentGoldOnArmy(gold + food / 2);
				b.ExecCmd(cmd, ptDummy, objDummy, false);
			}
	}
}

SetNoAIFlag(ol2, true);
ol.AddList(ol2);