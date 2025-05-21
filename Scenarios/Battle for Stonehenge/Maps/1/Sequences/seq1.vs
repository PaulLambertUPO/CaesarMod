int i, enemies;

Sleep(120000);

while (BlackOulderum.obj.player == 8) {
	enemies = 0;
	for (i = 1; i <= 5; i += 1)
		enemies += Subtract(ClassPlayerObjs("Military", i), ClassPlayerObjs("Sentry", i)).count;
	if (enemies / 11 > G_SpawnArmy.count)
		if (Intersect(AreaObjs("A_ReadyToGuard", "Unit"), EnemyObjs(8, "Unit")).IsEmpty())
			SpawnGroupInHolder("T_Spawn" + (rand(6) + 1), "AI_Settlement");
	Sleep(3500);
}