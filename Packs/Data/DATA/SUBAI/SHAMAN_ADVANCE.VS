//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(curse)) {//do not use GetBestCurseTarget because it is a bugged function: it does not work for mages but only for warriors
			ObjList ol;
			Obj o, target;
			int i, d, plr, best_dist = 10000000;

			plr = .player;

			if (!.InHolder) {
				ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
				for (i = ol.count - 1; i >= 0; i -= 1) {
					o = ol[i];
					if (o.IsAlive)
						if (!o.AsUnit().IsCursed) {
							d = .DistTo(o);
							if (target.IsDead) {
								target = o;
								best_dist = d;
							}
							else if (d < best_dist) {
								target = o;
								best_dist = d;
							}
						}
				}
			}
			if (target.IsDead)
				while (!.Goto(pt, 0, 2000, false, -1)) {
					best_dist = 10000000;
					ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
					for (i = ol.count - 1; i >= 0; i -= 1) {
						o = ol[i];
						if (o.IsAlive)
							if (!o.AsUnit().IsCursed) {
								d = .DistTo(o);
								if (target.IsDead) {
									target = o;
									best_dist = d;
								}
								else if (d < best_dist) {
									target = o;
									best_dist = d;
								}
							}
					}
					if (target.IsAlive)
						break;
					if (.TimeWithoutWalking >= 2500)
						break;
				}

			if (target.IsAlive) {
				.AddCommand(true, "advance", pt);
				.AddCommand(true, "curse", target);
			}
		}

Sleep(15);//prevent possible loops with other commands