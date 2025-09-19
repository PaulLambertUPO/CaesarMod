//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid) {
	ObjList pack;
	Unit u;
	point pt_move;
	rect rc;
	bool flee = false;

	rc = GetMapRect();

	.SetSpeedFactor(100);

	while (!.Stop(1000))
		;

	.Idle(500);

	while (1) {
		Sleep(500);

		if (rand(5) == 0)
			.Idle(1500);
		else {
			pt_move.SetLen(200 + rand(.sight));
			pt_move.Rot(rand(360));
			pt_move = .pos + pt_move;

			if (pt_move.InRect(rc))
				if (IsPassable3x3(pt_move))
					if (!IsPointInWater(pt_move)) {
						if (rand(3) == 0) {
							if (ObjsInCircle(pt_move, .sight, "Building").count > 0)
								continue;
							if (Intersect(ObjsInCircle(pt_move, .sight, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).count > 0)
								continue;
						}

						if (rand(5) == 0) {
							pack = Intersect(ObjsInRange(this, "Wolf", .sight / 2), FriendlyObjs(.player, "Wolf")).GetObjList();
							if (pack.count > 7) {
								u = pack[0];
								u.SetCommand("lead");	 
								pack.Remove(u);
								pack.SetCommand("idle");
							}
						}

						flee = false;

						while (!.Goto(pt_move, 0, 1000, true, 0)) {
							if (!.HasPath())
								break;
							if (!flee) {
								u = .BestTargetInSquadSight();
								if (u.IsValid)
									if (.DistTo(u) < .sight * 2 / 3) {
										.AddCommand(true, "engage");
										return;
									}
									else if (.health < .maxhealth * 9 / 10) {
										.AddCommand(true, "engage");
										return;
									}
									else
										flee = true;
							}
						}
					}
		}
	}
}