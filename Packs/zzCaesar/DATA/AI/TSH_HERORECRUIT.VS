//void, Settlement set, Hero *h

ObjList ol;
int nRace, i;
str cmd;
Hero hh;

nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome) {
	if (IsResearched(set, "ChooseImperialRome"))
		cmd = "hireheroRImperial";
	else if (IsResearched(set, "ChoosePunicRome"))
		cmd = "hireheroRPunic";
	else
		cmd = "hireheroR";
}
else if (nRace == ImperialRome)//Greece
	cmd = "hireheroH";
else
	cmd = "hirehero" + GetRaceStrPref(nRace);

//steal from the AI
ol = GetGAIKA(set.GetCentralBuilding()).GetAIControlledUnits("Hero", set.player, 1, false);
for (i = 0; i < ol.count; i += 1) {
	hh = ol[i].AsHero();
	if (hh.IsAlive) {
		hh.SetNoAIFlag(true);
		hh.DetachArmy();
		h = hh;
		break;
	}
}

if (!h.IsAlive) {
	bool hero_needed = true;
	ObjList arenae;
	if (nRace == ImperialRome) {//Greece
		ObjList buildings;
		buildings = set.Buildings;
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HGymnasium")
				arenae.Add(buildings[i]);
	}
	else
		arenae = set.TSGetAllArenae();
	for (i = 0; i < arenae.count; i += 1)
		if (arenae[i].CmdCount(cmd) > 0) {
			hero_needed = false;
			break;
		}
	if (hero_needed) {
		int gold, food;
		if (GetCmdCost(cmd, gold, food))
			if (set.CanAfford(cmd)) {
				set.SpentGoldOnArmy(gold + food / 2);
				set.Research(cmd);
			}
	}
}