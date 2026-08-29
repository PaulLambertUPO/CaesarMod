//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(curse)) {//do not use GetBestCurseTarget because it is a bugged function: it does not work for mages but only for warriors
			ObjList ol;
			Obj o, target;
			int i, d, plr, j = 4, best_dist = 10000000;

			plr = .player;

			if (!.InHolder) {
				ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
				for (i = ol.count - 1; i >= 0; i -= 1) {
					o = ol[i];
					if (o.IsAlive)
						if (!o.AsShip().IsValid)
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
			while (!.Goto(pt, 0, 2000, false, -1)) {
				best_dist = 10000000;
				ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
				for (i = ol.count - 1; i >= 0; i -= 1) {
					o = ol[i];
					if (o.IsAlive)
						if (!o.AsShip().IsValid)
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
					if (.DistTo(pt) < .sight)
						break;
				if (.TimeWithoutWalking >= 2500)
					break;
			}

			while (j > 0) {//total loop duration must be lower than the curse effect (CurseTimeout)
				if (target.IsAlive)
					break;
				Sleep(750);
				best_dist = 10000000;
				ol = Intersect(VisibleObjsInSight(this, "Military,AttackAnimal"), EnemyObjs(plr, "Unit")).GetObjList();
				for (i = ol.count - 1; i >= 0; i -= 1) {
					o = ol[i];
					if (o.IsAlive)
						if (!o.AsShip().IsValid)
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
				j -= 1;
			}

			if (target.IsAlive) {
				.AddCommand(true, "curse", pt);
				.AddCommand(true, "curse", target);
			}
		}

Sleep(30);//prevent possible loops with other commands