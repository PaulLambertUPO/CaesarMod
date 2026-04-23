//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		point pt;

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else {
				if (.IsVisible)
					if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
						.AddCommand(true, "advance", .pos);
						break;
					}

				if (.Stop(2000)) {
					if (.AI) {
						if (rand(6) == 0)
							if (.IsEnemyInSquadSight) {
								o = Intersect(ObjsInSight(this, "BaseTownBuilding"), EnemyObjs(.player, "BaseTownBuilding")).GetObjList()[0];
								if (o.IsValid) {
									.AddCommand(true, "capture", o);
									break;
								}
							}
						if (!.hero.IsValid)
							if (IsWaterLsa(GetGAIKA(this).LSA)) {//leave the coast
								pt = .pos + RandomOffset(500);
								if (pt.InRect(GetMapRect()))
									if (IsPassable3x3(pt))
										if (!IsWaterLsa(pt.GetGAIKA().LSA)) {
											.AddCommand(true, "advance", pt);
											break;
										}
							}
					}

					.Idle(2000);
					if (rand(10) == 0) {
						pt = .GetDir();
						pt.SetLen(100);
						pt.Rot(30 - rand(61));
						.Face(pt + .pos);
					}
				}
			}
	}

Sleep(15);//prevent possible loops with other commands