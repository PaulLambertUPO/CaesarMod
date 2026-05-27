//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building target;

		target = other.AsBuilding();

		if (target.IsValid)
			if (target.IsAlive)
				if (.IsEnemy(target)) {
					point target_pos, pt_target;
					int rng;

					rng = .radius + 10;
					target_pos = target.pos;

					if (target.IsGate) {
						point pt_0, pt_1;

						pt_0 = target.GetPoint(17, 0);
						pt_1 = target.GetPoint(17, 1);

						if (pt_0.x != -32768 || pt_1.x != -32768) {
							int dist_0, dist_1;

							dist_0 = -1;
							dist_1 = -1;

							if (pt_0.x != -32768) {
								pt_0 = pt_0 + target_pos;
								dist_0 = .DistTo(pt_0);
								pt_target = pt_0;
							}
							if (pt_1.x != -32768) {
								pt_1 = pt_1 + target_pos;
								dist_1 = .DistTo(pt_1);
								pt_target = pt_1;
							}

							if (dist_0 >= 0) {
								rng = 0;
								if (dist_1 >= 0)
									if (dist_1 < dist_0)
										pt_target = pt_1;
									else
										pt_target = pt_0;
								else
									pt_target = pt_0;
							}
							else if (dist_1 >= 0) {
								rng = 0;
								pt_target = pt_1 + target_pos;
							}
						}
						else {//this happens only with German gates
							point pt;
							int i, j;

							for (i = 0; i < 3; i += 1) {
								pt = target.GetPoint(10, i);
								if (pt.x != -32768) {
									j += 1;
									pt_target = pt_target + pt + target_pos;
								}
							}
							if (j < 1) {//no "etDestLock2" points
								Sleep(30);//prevent possible loops with other commands
								return;
							}
							pt_target = pt_target / j;
						}
					}
					else if (target.settlement.IsOutpost || target.settlement.IsShipyard) {
						point pt;
						int i, dist_x, dist_y, radius, best_radius = 100000000;

						while (true) {
							pt = target.GetPoint(17, i);
							if (pt.x == -32768)
								break;
							i += 1;
							pt = pt + target_pos;
							dist_x = pt.x - .pos.x;
							dist_y = pt.y - .pos.y;
							radius = dist_x * dist_x + dist_y * dist_y;
							if (radius < best_radius) {
								best_radius = radius;
								pt_target = pt;
								rng = 0;
							}
						}

						if (i < 1) {
							while (true) {
								pt = target.GetPoint(1, i);
								if (pt.x == -32768)
									break;
								i += 1;
								pt = pt + target_pos;
								dist_x = pt.x - .pos.x;
								dist_y = pt.y - .pos.y;
								radius = dist_x * dist_x + dist_y * dist_y;
								if (radius < best_radius) {
									best_radius = radius;
									pt_target = pt;
								}
							}
							if (i < 1) {//no enter points
								Sleep(30);//prevent possible loops with other commands
								return;
							}
						}
					}
					else {
						Sleep(30);//prevent possible loops with other commands
						return;
					}

					while (!.GotoEnter(pt_target, rng, 2000, false, 0))
						;

					while (.CanAttack(target)) {
						if (target.IsVeryBroken)
							break;
						if (!.IsEnemy(target))
							break;
						.Attack(target);
					}
				}
	}

Sleep(30);//prevent possible loops with other commands