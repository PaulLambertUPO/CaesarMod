//void, Settlement set

//called by ES_Stronghold, this script manages barrack upgrades to speed up unit recruitment

int Greece, nRace;
str strTech = "Barrack Level 1";

Greece = ImperialRome;
nRace = set.GetCentralBuilding().race;

if (IsResearched(set, strTech)) {
	int AIPlayer, nUpgradeBarracks;

	AIPlayer = set.player;
	nUpgradeBarracks = AIVar(AIPlayer, AIV_UpgradeBarracks);

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
		if (set.CanAfford(strTech)) {
			ObjList buildings;
			Barrack barrack;
			str barrack_class;
			int i, min;
			bool first_time = true;

			if (nRace == Greece)
				barrack_class = "HBarracks";
			else
				barrack_class = GetRaceStrPref(nRace) + "Barracks";
			buildings = set.Buildings();

			for (i = 0; i < buildings.count; i += 1)
				if (buildings[i].class == barrack_class)
					if (first_time || buildings[i].CmdCount < min) {
						first_time = false;
						min = buildings[i].CmdCount;
						barrack = buildings[i];
					}
			if (barrack.IsValid) {
				int gold, food;
				if (GetCmdCost(strTech, gold, food)) {
					point ptDummy;
					Obj objDummy;
					set.SpentGoldOnTech(gold + food / 2);
					barrack.ExecCmd(strTech, ptDummy, objDummy, false);
				}
			}
		}