//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			ObjList pack;
			Obj target;
			point pt_move;
			rect rc;
			bool flee = false;

			rc = GetMapRect();

			while (.CmdCount <= 1)//avoid blocking pending commands forever
				if (rand(5) == 0)
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

								if (rand(5) == 0) {
									pack = Intersect(
										Union(ObjsInRange(this, "LionM", .sight / 2), ObjsInRange(this, "LionF", .sight / 2)),
										Union(FriendlyObjs(.player, "LionM"), FriendlyObjs(.player, "LionF"))
									).GetObjList();
									if (pack.count > 7) {
										target = pack[rand(pack.count)];
										target.SetCommand("lead");
										pack.Remove(target);
										pack.SetCommand("idle");
									}
								}

								flee = false;

								while (!.Goto(pt_move, 0, 2000, false, 1000))
									if (!flee) {
										target = .BestTargetInSquadSight;
										if (target.IsAlive)
											if (.DistTo(target) < .sight * 2 / 3) {
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