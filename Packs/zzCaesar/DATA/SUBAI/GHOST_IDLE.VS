//void, Obj me

Unit this;

this = me.AsGhost();

if (.IsValid) {
	ObjList ol_enemies;

	if (.GetAnim() == 17)//spawn
		Sleep(.TimeToAnimFinish);

	while (!.Stop(1000))
		;

	while (1) {
		.Idle(500);

		ol_enemies = Intersect(VisibleObjsInSight(this, "Military,Peaceful"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "Peaceful"))).GetObjList();

		if (ol_enemies.count > 0) {//move to the central point among enemies that can be damaged
			Unit u;
			point pt_move;
			int i, j;

			for (i = 0; i < ol_enemies.count; i += 1) {
				u = ol_enemies[i].AsUnit();
				if (u.IsValid)
					if (u.health > u.maxhealth / 5) {
						pt_move = pt_move + u.pos;
						j += 1;
					}
			}

			if (j > 0) {
				pt_move = pt_move / j;
				if (.DistTo(pt_move) > 60) {//this reduces the risk of a move-idle loop
					.AddCommand(true, "move", pt_move);
					return;
				}
			}
		}
	}
}