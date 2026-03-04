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

		if (!.InHolder)
			while (!.Stop(1000))
				;

		while (1)
			if (.InHolder)
				Sleep(2500);
			else if (rand(5) == 0)
				.Idle(1500);
			else {
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
								dangers = VisibleObjsInSight(this, "Building,Unit").GetObjList();
								if (dangers.count > 0) {//find the centre among all dangers and flee in the opposite direction
									pt_move.Set(0, 0);
									for (i = dangers.count - 1; i >= 0; i -= 1)
										pt_move = pt_move + dangers[i].pos;

									pt_move = .pos - (pt_move / dangers.count);
									pt_move.SetLen(.sight * 4);

									.AddCommand(true, "move", (pt_move + .pos).ClampToMap());
									return;
								}
							};

							fast_walk = !fast_walk;
							i = 0;
						}
					}
					else
						i += 1;//this is to avoid getting stuck when there is not much space and the walk speed is low

				Sleep(500);
			}
	}