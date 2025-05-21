//void, Settlement set, int num, ObjList ol

//called by specific tactic scripts (TS_...Tactic), this script manages the recruitment of magic units (temple)

ObjList ol1, ol2;
int Greece, nRace, i;
str class, cmd;

Greece = ImperialRome;
nRace = set.GetCentralBuilding().race;
if (nRace == Greece)
	class = "HPriest";
else if (nRace == RepublicanRome) {
	if (IsResearched(set, "ChoosePunicRome"))
		class = "RPriestPunic";
	else
		class = "RPriest";
}
else
	class = TempleUType(nRace);
cmd = "train" + class;//do not use TempleUTrain(nRace) because it is a bugged function: it causes a game crash for Germany, while for Egypt and Britain it returns the wrong class...

if (num) {//steal from the AI
	Unit u;
	ol1 = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits(class, set.player, num, true);
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
	ObjList temples;
	if (nRace == Greece) {
		ObjList buildings;
		buildings = set.Buildings();
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HTemple")
				temples.Add(buildings[i]);
	}
	else
		temples = set.TSGetAllTemples();
	for (i = 0; i < temples.count; i += 1)
		num -= temples[i].CmdCount(cmd);
}

if (num) {//issue commands
	Building b;
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
				if (buildings[j].class == "HTemple")
					if (first_time || buildings[j].CmdCount < min) {
						first_time = false;
						min = buildings[j].CmdCount;
						b = buildings[j];
					}
		}
		else
			b = set.BestTemple();
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