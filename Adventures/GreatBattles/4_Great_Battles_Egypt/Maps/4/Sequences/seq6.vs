SpawnGroupInHolder("E_MemphisDefence", "S_Memphis");

{
	Hero h;
	int i;
	for (i = 1; i <= 3; i += 1) {
		h = GetNamedObj("E_MemphisDefenceHero" + i).obj.AsHero();
		Group("E_MemphisDefence" + i).SetCommand("attach", h);
		h.SetAutocast(true);
	}
}

while (!E_MemphisDefence.IsEmpty()) {
	if (NO_Memphis.obj.player != 4) {
		StopAIHelper("RetakeMemphisVillage");
		StopAIHelper("ProtectMemphis");
		if (!IsAIHelperRunning("RetakeMemphis"))
			RunAIHelper("RetakeMemphis", "siege", "E_MemphisDefence", "S_Memphis");
	}
	else {
		StopAIHelper("RetakeMemphis");
		if (!Intersect(EnemyObjs(4, "Unit"), AreaObjs("A_MemphisDefence", "Unit")).IsEmpty()) {
			StopAIHelper("RetakeMemphisVillage");
			if (!IsAIHelperRunning("ProtectMemphis"))
				RunAIHelper("ProtectMemphis", "guard area", "E_MemphisDefence", "A_MemphisDefence");
		}
		else if (NO_V6.obj.player != 4) {
			StopAIHelper("ProtectMemphis");
			if (!IsAIHelperRunning("RetakeMemphisVillage"))
				RunAIHelper("RetakeMemphisVillage", "siege", "E_MemphisDefence", "S_V6");
		}
		else if (E_MemphisDefence.InHolder("S_Memphis") < E_MemphisDefence.count) {
			StopAIHelper("RetakeMemphisVillage");
			StopAIHelper("ProtectMemphis");
			E_MemphisDefence.SetCommand("enter", NO_Memphis);
		}
	}
	Sleep(2000);
}