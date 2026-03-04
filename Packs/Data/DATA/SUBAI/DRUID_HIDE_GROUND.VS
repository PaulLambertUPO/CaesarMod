//void, Obj This, point pt

Druid this;

this = This.AsDruid();

if (.IsValid)
	if (.IsAlive)
		if (.HasSpecial(invisibility)) {
			int plr;

			plr = .player;

			if (IsResearched(plr, "Mass Concealment")) {//do not use FindUnitToHide because it is a bugged function: it always returns an invalid unit
				ObjList ol;
				Obj o, target;
				str cmd;
				int i, d, j = 4, best_dist = 10000000;

				if (!.InHolder) {
					ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(plr, "Military")).GetObjList();
					for (i = ol.count - 1; i >= 0; i -= 1) {
						o = ol[i];
						if (o.IsAlive)
							if (o.player == plr)
								if (o.IsVisible) {
									cmd = o.command;
									if (cmd != "engage")
										if (cmd != "attack")
											if (cmd != "capture")
												if (!o.IsSentry)
													if (!o.IsRam)
														if (!o.AsShip().IsValid)
															if (!o.AsUnit().IsEnemyInSquadSight) {
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
				}
				while (!.Goto(pt, 0, 2000, false, -1)) {
					best_dist = 10000000;
					ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(plr, "Military")).GetObjList();
					for (i = ol.count - 1; i >= 0; i -= 1) {
						o = ol[i];
						if (o.IsAlive)
							if (o.player == plr)
								if (o.IsVisible) {
									cmd = o.command;
									if (cmd != "engage")
										if (cmd != "attack")
											if (cmd != "capture")
												if (!o.IsSentry)
													if (!o.IsRam)
														if (!o.AsShip().IsValid)
															if (!o.AsUnit().IsEnemyInSquadSight) {
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
					if (target.IsAlive)
						if (.DistTo(pt) < .sight)
							break;
					if (.TimeWithoutWalking >= 2500)
						break;
				}

				while (j > 0) {
					if (target.IsAlive)
						break;
					Sleep(750);
					best_dist = 10000000;
					ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(plr, "Military")).GetObjList();
					for (i = ol.count - 1; i >= 0; i -= 1) {
						o = ol[i];
						if (o.IsAlive)
							if (o.player == plr)
								if (o.IsVisible) {
									cmd = o.command;
									if (cmd != "engage")
										if (cmd != "attack")
											if (cmd != "capture")
												if (!o.IsSentry)
													if (!o.IsRam)
														if (!o.AsShip().IsValid)
															if (!o.AsUnit().IsEnemyInSquadSight) {
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
					j -= 1;
				}

				if (target.IsAlive) {
					.AddCommand(true, "hide", pt);
					.AddCommand(true, "hide", target);
				}

				if (.IsVisible)
					.AddCommand(true, "hide", this);
			}
			else
				while (!.Goto(pt, 0, 2000, false, 2500))
					;
		}

Sleep(15);//prevent possible loops with other commands