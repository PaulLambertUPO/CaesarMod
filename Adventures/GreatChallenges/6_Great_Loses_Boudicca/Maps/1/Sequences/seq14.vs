ObjList ol;
IntArray guards;
int dmg, i;

dmg = 6 + GetDifficulty() * 2;

while (!DungeonGuards.IsEmpty()) {
	ol = Intersect(EnemyObjs(8, cUnit), AreaObjs("A_Dungeon", cUnit)).GetObjList();
	ol.ClearDead();
	for (i = 0; i < ol.count; i += 1) {
		ol[i].Damage(dmg);
		CreateFeedback("Damage2", ol[i].AsUnit());
	}
	for (i = 1; i <= 11; i += 1)
		if (guards[i] != 1)
			if (!Intersect(EnemyObjs(8, cUnit), AreaObjs("A_DungeonGuard" + i, cUnit)).IsEmpty()) {
				RunAIHelper("DungeonGuard" + i, "guard area", "DungeonGuards" + i, "A_DungeonGuard" + i);
				guards[i] = 1;
			}
	Sleep(3000);
}