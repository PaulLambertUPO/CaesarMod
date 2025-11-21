//void, Settlement set, int num, ObjList ol

//called by specific tactic scripts (TS_...Tactic), this script manages the recruitment of magic units (temple)
//IMPORTANT: do not assign directly to ol because it references the original list (only use Add/Remove to update it)

ObjList ol1;
int nRace, i;
str class, cmd;

nRace = set.GetCentralBuilding().race;

if (nRace == ImperialRome)//Greece
	class = "HPriest";
else if (nRace == RepublicanRome) {
	if (IsResearched(set, "ChoosePunicRome"))
		class = "RPriestPunic";
	else
		class = "RPriest";
}
else
	class = TempleUType(nRace);
cmd = "train" + class;//do not use TempleUTrain(nRace) because it is a bugged function: it causes a game crash for Germany, while for Egypt and Britain it returns the wrong class

if (num > 0) {//steal from the AI
	ObjList ol2;
	Unit u;
	ol2 = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits(class, set.player, num, true);
	for (i = 0; i < ol2.count; i += 1) {
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
	ObjList temples;
	if (nRace == ImperialRome) {//Greece
		ObjList buildings;
		buildings = set.Buildings;
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HTemple")
				temples.Add(buildings[i]);
	}
	else
		temples = set.TSGetAllTemples();
	for (i = 0; i < temples.count; i += 1)
		num -= temples[i].CmdCount(cmd);
}

if (num > 0) {//issue commands
	Building temple;
	int gold, food;
	point ptDummy;
	Obj objDummy;
	for (i = 0; i < num; i += 1) {
		if (nRace == ImperialRome) {//Greece
			ObjList buildings;
			Building b;
			int j, min;
			bool first_time = true;
			buildings = set.Buildings;
			for (j = 0; j < buildings.count; j += 1) {
				b = buildings[j];
				if (b.IsHeirOf("HTemple"))//using IsHeirOf is better than a direct class check because it manages winter variants
					if (!b.IsBroken)
						if (first_time) {
							first_time = false;
							min = b.CmdCount;
							temple = b;
						}
						else if (b.CmdCount < min) {
							min = b.CmdCount;
							temple = b;
						}
			}
		}
		else
			temple = set.BestTemple();
		if (temple.IsValid)
			if (!temple.IsBroken)
				if (GetCmdCost(cmd, gold, food)) {
					if (!set.CanAfford(cmd))
						break;
					set.SpentGoldOnArmy(gold + food / 2);
					temple.ExecCmd(cmd, ptDummy, objDummy, false);
				}
	}
}

SetNoAIFlag(ol1, true);
ol.AddList(ol1);