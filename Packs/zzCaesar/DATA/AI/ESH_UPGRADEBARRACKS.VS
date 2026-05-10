//void, Settlement set

//called by ES_Stronghold, this script manages barrack upgrades to speed up unit recruitment times

str strTech = "Barrack Level 1";

if (IsResearched(set, strTech)) {
	int aiPlayer, nUpgradeBarracks;

	aiPlayer = set.player;
	nUpgradeBarracks = AIVar(aiPlayer, AIV_UpgradeBarracks);

	if (nUpgradeBarracks > 1) {
		strTech = "Barrack Level 2";
		if (IsResearched(set, strTech))
			if (nUpgradeBarracks > 2) {
				strTech = "Barrack Level 3";
				if (IsResearched(set, strTech))
					strTech = "";
			}
			else
				strTech = "";
	}
	else
		strTech = "";
}
if (strTech != "")
	if (rand(20) == 0)//the random is to avoid an instant rush for the upgrade (stronghold script loop frequency is quite high)
		if (!IsResearching(set, strTech))
			if (set.CanAfford(strTech)) {//do not use CanResearch because training commands in progress make it return false
				ObjList buildings;
				Building b;
				Barrack barrack;
				str barrack_class;
				int nRace, i, min;
				bool first_time = true;

				nRace = set.GetCentralBuilding().race;

				if (nRace == ImperialRome)//Greece
					barrack_class = "HBarracks";
				else
					barrack_class = GetRaceStrPref(nRace) + "Barracks";

				buildings = set.Buildings;
				for (i = buildings.count - 1; i >= 0; i -= 1) {
					b = buildings[i];
					if (b.IsHeirOf(barrack_class))//using IsHeirOf is better than a direct class check because it manages winter variants
						if (!b.IsBroken)
							if (first_time) {
								first_time = false;
								min = b.CmdCount;
								barrack = b;
							}
							else if (b.CmdCount < min) {
								min = b.CmdCount;
								barrack = b;
							}
				}
				if (barrack.IsValid)
					if (!barrack.IsBroken) {
						int gold, food;
						if (GetCmdCost(strTech, gold, food)) {
							point ptDummy;
							Obj objDummy;
							set.SpentGoldOnTech(gold + food / 2);
							barrack.ExecCmd(strTech, ptDummy, objDummy, false);
						}
					}
			}