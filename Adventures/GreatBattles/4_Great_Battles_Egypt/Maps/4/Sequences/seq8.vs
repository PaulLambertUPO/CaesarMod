SpawnGroupInHolder("E_GoldDefence", "S_O9");

NO_O9.SetCommand("tribute", NO_Alexandria);

while (!E_GoldDefence.IsEmpty()) {
	if (!Intersect(
				EnemyObjs(4, cUnit),
				Union(AreaObjs("A_GoldDefence", cUnit), AreaObjs("A_GoldDefence", cCatapult))
			).IsEmpty()) {
		if (!IsAIHelperRunning("ProtectGold"))
			RunAIHelper("ProtectGold", "guard area", "E_GoldDefence", "A_GoldDefence");
	}
	else {
		StopAIHelper("ProtectGold");
		if (E_GoldDefence.InHolder("S_O9") < E_GoldDefence.count)
			E_GoldDefence.SetCommand("enter", NO_O9);
	}
	Sleep(2000);
}