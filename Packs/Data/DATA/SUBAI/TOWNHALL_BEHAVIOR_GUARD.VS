//void, Obj This

Sleep(1000 + rand(1001));

if (This.AsBuilding().IsValid) {
	Settlement this;
	ObjList ol;
	point pt_pos, pt;
	int plr, rad, write_alert;

	this = This.AsBuilding().settlement;

	pt_pos = This.pos;

	plr = .player;
	rad = This.radius + 10;

	while (true) {
		if (.player != plr)
			plr = .player;

		pt.Set(0, rad);
		pt.Rot(rand(360));
		.Units.ObjEnemy(plr).SetCommand("advance", pt + pt_pos);//send away enemy units inside

		ol = Intersect(
			VisibleObjsInSight(This, "Military,BaseMage,AttackAnimal,GGhostUnit,Catapult"),
			Union(EnemyObjs(plr, "Unit"), EnemyObjs(plr, "Catapult"))
		).GetObjList();

		if (ol.count > 0) {
			if (write_alert != 1) {
				EnvWriteInt(this, "EnemiesAlert", 1);//EnemiesAlert is used in "GS_KillEnemies.vs"
				write_alert = 1;
			}

			pt = ol[0].pos;

			ol = .Units;

			ol.SetCommand("advance", pt);
			ol.AddCommand(false, "advance_enter", This);
		}
		else if (write_alert != 0) {
			EnvWriteInt(this, "EnemiesAlert", 0);
			write_alert = 0;
		}

		Sleep(2000);
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);