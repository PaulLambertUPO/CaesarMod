Obj hall;

Sleep(120000);

hall = BlackOulderum;

while (hall.player == 8) {
	if (EnemyMilUnits(8) > G_SpawnArmy.count * 5)
		if (Intersect(AreaObjs("A_ReadyToGuard", "Unit"), EnemyObjs(8, "Unit")).IsEmpty)
			SpawnGroupInHolder("T_Spawn" + (rand(6) + 1), hall);
	Sleep(15000);
}