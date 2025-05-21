Settlement set;
StrArray researches;
int i, k, s, research_timer, timer;

set = GetSettlement("S_GreenTown");

researches[0] = "Gambler's Day";
researches[1] = "Gambler's Test";
researches[2] = "Gambler's Luck";
researches[3] = "BNobility";
researches[4] = "Noble Offence";
researches[5] = "Noble Defence";

research_timer = 480000 - GetDifficulty() * 60000;
timer = research_timer;

while (set.player == 3) {
	set.SetGold(2000);
	if (s < 6) {
		timer -= 5000;
		if (timer <= 0) {
			timer = research_timer;
			set.GetCentralBuilding().Research(researches[s]);
			s += 1;
		}
	}
	for (i = 1; i <= 3; i += 1)
		if (GetNamedObj("BritonOutpost" + i).obj.player == 1)
			k += 1;
	if (k >= 3)
		break;
	k = 0;
	Sleep(5000);
}

if (IsNoteActive("GreenTown"))
	RemoveNote("GreenTown");

if (k >= 3)
	if (set.player == 3) {
		ObjList ol;
		Hero h;
		int i;

		DiplCeaseFire(1, 3, true);
		DiplCeaseFire(3, 1, true);
		DiplShareView(1, 3, true);
		DiplShareView(3, 1, true);
		DiplShareSupport(1, 3, true);
		DiplShareSupport(3, 1, true);
		DiplShareControl(1, 3, true);
		DiplShareControl(3, 1, true);

		StopAIHelper("Guard_Trinovantes");

		if (!GreenHero.IsDead()) {
			if (GreenHero.obj.AsUnit().InHolder) {
				GreenHero.SetCommand("move", Point(6124, 1705));
				Sleep(2500);
			}
			RunConv("JoinGreenTown");
		}

		ol = GetPlayerUnits(3, cHero);
		ol.ClearDead();
		for (i = 0; i < ol.count; i += 1) {
			h = ol[i].AsHero();
			if (h.IsValid)
				h.SetAutocast(false);
		}

		GreenObjects.SetPlayer(1);
		if (BritVillage1.obj.player == 3)
			BritVillage1.SetPlayer(1);
		if (BritVillage2.obj.player == 3)
			BritVillage2.SetPlayer(1);
	}