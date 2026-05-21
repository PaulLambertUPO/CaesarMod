//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Settlement set;
		Obj o;
		point pt;

		Sleep(rand(151));//avoid "thundering herd" for multiple units that start the command simultaneously

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else {
				if (.IsVisible)
					if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
						.AddCommand(true, "advance", .pos);
						break;
					}

				if (.Stop(2000)) {
					if (.AI)
						if (.hero.IsDead) {
							if (rand(6) == 0)
								if (.IsEnemyInSquadSight) {
									set = GetGAIKA(this).settlement;
									if (set.IsValid)
										if (set.IsStronghold)
											if (set.IsEnemy(.player))
												if (.DistTo(set.GetCentralBuilding()) < 700) {
													.AddCommand(true, "capture", set.GetCentralBuilding());
													break;
												}
								}
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

Sleep(30);//prevent possible loops with other commands