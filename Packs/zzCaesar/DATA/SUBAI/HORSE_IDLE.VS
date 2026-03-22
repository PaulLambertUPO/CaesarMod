//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		ObjList dangers;
		point pt_move;
		rect rc;
		int i;
		bool fast_walk = false;

		rc = GetMapRect();

		while (1)
			if (.InHolder)
				Sleep(2500);
			else if (rand(5) == 0)
				.Idle(1500);
			else {
				Sleep(500);

				if (fast_walk)
					pt_move.SetLen(200 + rand(.sight));
				else
					pt_move.SetLen(15 + rand(21) + i);
				pt_move.Rot(rand(360));
				pt_move = .pos + pt_move;

				if (pt_move.InRect(rc))
					if (IsPassable3x3(pt_move)) {
						if (!IsPointInWater(pt_move)) {
							.Face(pt_move);
							if (fast_walk) {
								.SetSpeedFactor(150);
								.SetWalkAnim(1);
							}
							else {
								.SetSpeedFactor(7);
								.SetWalkAnim(13);
							}

							while (!.Goto(pt_move, 0, 2000, false, 0)) {
								dangers = Intersect(VisibleObjsInSight(this, "Building,Unit"), Union(EnemyObjs(.player, "Building"), EnemyObjs(.player, "Unit"))).GetObjList();
								if (dangers.count > 0) {//find the centre among all dangers and flee in the opposite direction
									pt_move.Set(0, 0);
									for (i = dangers.count - 1; i >= 0; i -= 1)
										pt_move = pt_move + dangers[i].pos;

									pt_move = .pos - (pt_move / dangers.count);

									if (.health <= .maxhealth * 3 / 4) {
										pt_move.SetLen(.sight * 4);
										.AddCommand(true, "move", (pt_move + .pos).ClampToMap());
									}
									else {
										pt_move.SetLen(.sight / 2);
										.AddCommand(true, "trot", (pt_move + .pos).ClampToMap());
									}
									return;
								}
							};

							if (fast_walk)
								fast_walk = false;
							else if (rand(10) == 0)
								fast_walk = true;
							i = 0;
						}
					}
					else
						i += 1;//this is to avoid getting stuck when there is not much space and the walk speed is low
			}
	}