//void, Settlement set, Hero *h

ObjList ol;
int Greece, nRace, i;
str cmd;
Hero hh;

Greece = ImperialRome;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome) {
	if (IsResearched(set, "ChooseImperialRome"))
		cmd = "hireheroRImperial";
	else if (IsResearched(set, "ChoosePunicRome"))
		cmd = "hireheroRPunic";
}
else if (nRace == Greece)
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
	ObjList barracks;
	if (nRace == Greece) {
		ObjList buildings;
		buildings = set.Buildings();
		for (i = 0; i < buildings.count; i += 1)
			if (buildings[i].class == "HGymnasium")
				barracks.Add(buildings[i]);
	}
	else
		barracks = set.TSGetAllBarracks();
	for (i = 0; hero_needed && i < barracks.count; i += 1)
		if (barracks[i].CmdCount(cmd))
			hero_needed = false;
	if (hero_needed) {
		int gold, food;
		if (GetCmdCost(cmd, gold, food))
			if (set.gold >= gold)
				if (set.food >= food)
					if (set.CanResearch(cmd)) {
						set.SpentGoldOnArmy(gold + food / 2);
						set.Research(cmd);
					}
	}
}