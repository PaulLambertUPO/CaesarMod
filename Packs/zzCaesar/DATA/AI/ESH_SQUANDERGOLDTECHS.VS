//void, Settlement set

//called by ES_Stronghold, this script manages some researches when there is a lot of gold in the stronghold

int aiPlayer, nRace;

aiPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (nRace == Germany) {//Germany researches are unlimited, so all of them are made twice to increase limits of all advanced units (and food is bought to recruit them)
	Building b;
	StrArray germanTechs;
	str cmd;
	int i, j, gold, food;
	point ptDummy;
	Obj objDummy;

	germanTechs[0] = "Axe production";
	germanTechs[1] = "Javelin production";
	germanTechs[2] = "Horseshoe production";
	germanTechs[3] = "Mace production";

	for (i = 0; i < 2; i += 1)
		for (j = 0; j < 4; j += 1) {
			cmd = germanTechs[j];
			if (GetCmdCost(cmd, gold, food)) {
				b = set.FindResearchLab(cmd);
				if (b.IsValid)
					if (!b.IsBroken) {
						set.SpentGoldOnTech(gold + food / 2);
						b.ExecCmd(cmd, ptDummy, objDummy, false);
					}
			}
		}
	cmd = "buyfoodforgold";
	if (GetCmdCost(cmd, gold, food)) {
		b = set.FindResearchLab(cmd);
		if (b.IsValid)
			if (!b.IsBroken) {
				i = 10;
				set.SpentGoldOnTech((gold + food / 2) * i);
				while (i > 0) {
					b.ExecCmd(cmd, ptDummy, objDummy, false);
					i -= 1;
				}
			}
	}
}
else if (nRace == Carthage)
	if (IsResearched(set, "People's Assembly")) {//prepare to train many elephants
		int gold, food;
		if (GetCmdCost("Mahout School", gold, food)) {
			Building b;
			b = set.FindResearchLab("Mahout School");
			if (b.IsValid)
				if (!b.IsBroken) {
					int i = 5;
					point ptDummy;
					Obj objDummy;
					set.SpentGoldOnTech((gold + food / 2) * i);
					while (i > 0) {
						b.ExecCmd("Mahout School", ptDummy, objDummy, false);
						i -= 1;
					}
				}
		}
		if (GetCmdCost("buyfoodforgold", gold, food)) {
			Building b;
			b = set.FindResearchLab("buyfoodforgold");
			if (b.IsValid)
				if (!b.IsBroken) {
					int i = 10;
					point ptDummy;
					Obj objDummy;
					set.SpentGoldOnTech((gold + food / 2) * i);
					while (i > 0) {
						b.ExecCmd("buyfoodforgold", ptDummy, objDummy, false);
						i -= 1;
					}
				}
		}
	}
	else {
		EnvWriteString(set, "strTech", "People's Assembly");
		set.AIRun("ESH_NeedTech.vs");
	}