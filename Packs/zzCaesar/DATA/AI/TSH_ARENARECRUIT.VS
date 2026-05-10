//void, Settlement set, int num, ObjList ol

//called by specific tactic scripts (TS_...Tactic), this script manages the recruitment of special units (arena)
//IMPORTANT: do not assign directly to ol because it references the original list (only use Add/Remove to update it)

ObjList ol1;
int nRace, nUnitsPerCommand, i;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;
str cmd, tech, class;

nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else if (IsResearched(set, "ChoosePunicRome"))
		nRaceIsPunicRome = true;

if (nRaceIsImperialRome) {
	cmd = "Hire Liberati";
	tech = "RGladiator Shows2";
	class = "RLiberatus";
	nUnitsPerCommand = 10;
}
else if (nRaceIsPunicRome) {
	cmd = "Hire Liberati Punic";
	tech = "Gladiator Shows";
	class = "RLiberatus";//do not use RLiberatusPunic otherwise GetAIControlledUnits below might give a wrong result
	nUnitsPerCommand = 10;
}
else if (nRace == ImperialRome) {//Greece
	cmd = "trainHMyrmidon";
	tech = "Olympic Games";
	class = "HMyrmidon_Javelin";
	nUnitsPerCommand = 1;
}
else if (nRace == Britain) {
	cmd = "Hire Viking Lord";
	tech = "Challenges";
	class = "BVikingLord";
	nUnitsPerCommand = 1;
}
else if (nRace == Germany) {
	cmd = "Call Valkyries";
	tech = "Tribal fights";
	class = "TValkyrie";
	nUnitsPerCommand = 5;
}
else {
	cmd = ArenaTrainCmd(nRace);
	tech = ArenaUTech(nRace);
	class = ArenaUType(nRace);
	nUnitsPerCommand = 1;
}

if (num > 0) {//steal from the AI
	ObjList ol2;
	Unit u;
	ol2 = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits(class, set.player, num, false);
	for (i = ol2.count - 1; i >= 0; i -= 1) {
		u = ol2[i].AsUnit();
		if (u.IsAlive) {
			if (u.hero.IsValid)
				u.DetachFrom(u.hero);
			ol1.Add(u);
		}
	}
	num -= ol1.count;
}

if (num > 0) {//count how many are queued
	ObjList arenae;
	if (nRace == ImperialRome) {//Greece
		ObjList buildings;
		buildings = set.Buildings;
		for (i = buildings.count - 1; i >= 0; i -= 1)
			if (buildings[i].class == "HGymnasium")
				arenae.Add(buildings[i]);
	}
	else
		arenae = set.TSGetAllArenae();
	for (i = arenae.count - 1; i >= 0; i -= 1)
		num -= arenae[i].CmdCount(cmd) * nUnitsPerCommand;
}

if (tech != "")
	if (IsResearched(set, tech)) {//issue commands
		Building arena;
		int gold, food;
		point ptDummy;
		Obj objDummy;
		num = (num + nUnitsPerCommand - 1) / nUnitsPerCommand;
		for (i = 0; i < num; i += 1) {
			if (nRace == ImperialRome) {//Greece
				ObjList buildings;
				Building b;
				int j, min;
				bool first_time = true;
				buildings = set.Buildings;
				for (j = buildings.count - 1; j >= 0; j -= 1) {
					b = buildings[j];
					if (b.IsHeirOf("HGymnasium"))//using IsHeirOf is better than a direct class check because it manages winter variants
						if (!b.IsBroken)
							if (first_time) {
								first_time = false;
								min = b.CmdCount;
								arena = b;
							}
							else if (b.CmdCount < min) {
								min = b.CmdCount;
								arena = b;
							}
				}
			}
			else
				arena = set.BestArena();
			if (arena.IsValid)
				if (!arena.IsBroken)
					if (GetCmdCost(cmd, gold, food)) {
						if (!set.CanAfford(cmd))
							break;
						set.SpentGoldOnArmy(gold + food / 2);
						arena.ExecCmd(cmd, ptDummy, objDummy, false);
					}
		}
	}

SetNoAIFlag(ol1, true);
ol.AddList(ol1);