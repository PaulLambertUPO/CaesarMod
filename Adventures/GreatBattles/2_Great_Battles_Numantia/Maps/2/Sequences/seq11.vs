Obj nearby_player_unit;

SpawnGroupInHolder("I_SmallTownDefence", "S_16");

{
	Hero h;
	int i;
	for (i = 1; i <= 3; i += 1) {
		h = GetNamedObj("I_SmallTownHero" + i).obj.AsHero();
		Group("I_SmallTownDefence" + i).SetCommand("attach", h);
		h.SetAutocast(true);
	}
}

while (!I_SmallTownDefence.IsEmpty()) {
	if (NO_16.obj.player == 1) {
		StopAIHelper("RetakeSmallVillage");
		if (!IsAIHelperRunning("RetakeSmallTown"))
			RunAIHelper("RetakeSmallTown", "siege", "I_SmallTownDefence", "S_16");
	}
	else {
		StopAIHelper("RetakeSmallTown");
		nearby_player_unit = ClassPlayerAreaObjs(cUnit, 1, "A_SmallTown").GetObjList()[0];
		if (nearby_player_unit.IsValid) {
			StopAIHelper("RetakeSmallVillage");
			I_SmallTownDefence.SetCommand("advance", nearby_player_unit.pos);
		}
		else if (NO_17.obj.player == 1) {
			if (!IsAIHelperRunning("RetakeSmallVillage"))
				RunAIHelper("RetakeSmallVillage", "siege", "I_SmallTownDefence", "S_17");
		}
		else if (I_SmallTownDefence.InHolder("S_16") < I_SmallTownDefence.count)
			I_SmallTownDefence.SetCommand("enter", NO_16);
	}
	Sleep(10000);
}