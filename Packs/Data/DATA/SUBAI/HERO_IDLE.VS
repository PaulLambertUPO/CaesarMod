//void, Obj This

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		point pt, pt_start;
		bool melee, go_back;

		Sleep(rand(151));//avoid "thundering herd" for multiple units that start the command simultaneously

		melee = !.IsRanged;

		{
			ObjList h_army;
			int i;

			h_army = .army;

			for (i = h_army.count - 1; i >= 0; i -= 1) {
				o = h_army[i];
				if (o.IsAlive)
					if (o.command == "form_move")
						o.SetCommand("idle");
			}
		}

		pt_start = .posRH;

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else {
				if (.IsVisible) {//do not use the engage/advance command otherwise the entire army will fight (capturing a building may become almost impossible)
					o = .BestTargetInSquadSightMisZeroDamage;
					while (.IsValidTarget(o)) {
						go_back = false;
						if (.GotoAttack(o, 1500, true, 15000))
							if (.IsVisible)
								if (.IsValidTarget(o))
									if (o.AsCatapult().IsValid)
										while (.Attack(o)) {
											if (melee)
												if (.HasSpecial(trample))
													o.Damage(.damage);
											if (!.IsVisible)
												break;
										}
									else
										while (.Attack(o))
											if (!.IsVisible)
												break;
						if (!.IsVisible)
							go_back = true;
						else {
							o = .BestTargetInSquadSightMisZeroDamage;
							if (!.IsValidTarget(o))
								go_back = true;
						}
						if (go_back) {
							o.Clear();
							while (!.Goto(pt_start, 0, 1500, false, 2500))
								if (.IsVisible) {
									o = .BestTargetInSquadSightMisZeroDamage;
									if (.IsValidTarget(o))
										break;
								}
						}
					}
				}

				if (.Stop(2000)) {
					if (.AI) {
						if (rand(3) == 0)
							if (.IsEnemyInSquadSight) {
								o = Intersect(ObjsInSight(this, "BaseTownBuilding"), EnemyObjs(.player, "BaseTownBuilding")).GetObjList()[0];
								if (o.IsValid) {
									.AddCommand(true, "capture", o);
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