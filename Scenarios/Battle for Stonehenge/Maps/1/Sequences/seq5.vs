Building black_stone;
Obj hall;

Sleep(300000);

black_stone = BlackStone.obj.AsBuilding();
hall = BlackOulderum;

while (hall.player == 8) {
	if (Intersect(AreaObjs("A_CastSpell", "Unit"), EnemyObjs(8, cUnit)).IsEmpty) {
		if (T_BlackMagic.IsEmpty)
			SpawnGroup("T_BlackMagic").SetCommand("stand_position");
		EnvWriteInt(black_stone, "CasterPlayer", 8);
		if (MilUnits(8) > EnemyMilUnits(8) * 5)
			black_stone.SetCommand("plague");
		else if (EnemyCount(8, "BaseMage") >= 40)
			black_stone.SetCommand("sacrifice");
		else if (GetSettlements("Outpost", 8).count > 4)
			black_stone.SetCommand("gold_rain");
		else if (EnemyMilUnits(8) > MilUnits(8) * 10)
			black_stone.SetCommand("plague");
		else if (GetSettlements("BaseVillage", 8).count < 5)
			black_stone.SetCommand("starvation");
		else if (GetSettlements("Outpost", 8).count < 2)
			black_stone.SetCommand("uprising");
		else if (GetSettlements("BaseTownhall", 8).count > 3)
			black_stone.SetCommand("teuton_horde");
		Sleep(500);
		while (black_stone.command != "idle")
			Sleep(10000);
	}
	Sleep(30000);
}