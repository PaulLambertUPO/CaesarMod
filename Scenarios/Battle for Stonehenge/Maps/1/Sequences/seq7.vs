Building black_stone;

black_stone = BlackStone.obj.AsBuilding();

Sleep(600000);

while (BlackOulderum.obj.player == 8) {
	if (Intersect(AreaObjs("A_CastSpell", "Unit"), EnemyObjs(8, cUnit)).IsEmpty()) {
		if (T_BlackMagic.IsEmpty())
			SpawnGroup("T_BlackMagic").SetCommand("stand_position");
		EnvWriteInt(black_stone, "OwningPlayer", 8);
		if (EnemyCount(8, "BaseMage") >= 40) {
			black_stone.GlobalSpellStart(gsDivineSacrifice, 8);
			black_stone.SetCommand("sacrifice");
			Sleep(60000);
		}
		else if (Union(ClassPlayerObjs("ROutpost", 8), ClassPlayerObjs("BaseVillage", 8)).count >= 18) {
			black_stone.SetCommand("gold_rain");
			Sleep(120000);
		}
		else if (ClassPlayerObjs("BaseVillage", 8).count >= 16) {
			black_stone.GlobalSpellStart(gsStarvation, 8);
			black_stone.SetCommand("starvation");
			Sleep(120000);
		}
	}
	Sleep(30000);
}