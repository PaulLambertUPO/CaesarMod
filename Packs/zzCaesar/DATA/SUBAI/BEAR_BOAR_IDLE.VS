//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Obj enemy;
		point pt_move;
		rect rc;
		bool flee = false;

		.SetSpeedFactor(100);

		rc = GetMapRect();

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else if (rand(5) == 0)
				.Idle(1500);
			else {
				Sleep(500);

				pt_move.SetLen(200 + rand(.sight));
				pt_move.Rot(rand(360));
				pt_move = .pos + pt_move;

				if (pt_move.InRect(rc))
					if (IsPassable3x3(pt_move))
						if (!IsPointInWater(pt_move)) {
							if (rand(3) == 0) {
								if (!ObjsInCircle(pt_move, .sight, "Building").IsEmpty)
									continue;
								if (!Intersect(ObjsInCircle(pt_move, .sight, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).IsEmpty)
									continue;
							}

							flee = false;

							while (!.Goto(pt_move, 0, 2000, false, 1500))
								if (!flee) {
									enemy = .BestTargetInSquadSight;
									if (enemy.IsAlive)
										if (.DistTo(enemy) < .sight * 2 / 3) {
											.AddCommand(true, "engage");
											Sleep(30);//prevent possible loops with other commands
											return;
										}
										else if (.health < .maxhealth * 9 / 10) {
											.AddCommand(true, "engage");
											Sleep(30);//prevent possible loops with other commands
											return;
										}
										else
											flee = true;
								}
						}
			}
	}

Sleep(30);//prevent possible loops with other commands