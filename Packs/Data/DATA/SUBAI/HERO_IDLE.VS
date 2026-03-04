//void, Obj This

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		point pt, pt_start;
		bool melee, go_back;

		melee = !.IsRanged;

		{
			ObjList army;
			int i;

			army = .army;

			for (i = army.count - 1; i >= 0; i -= 1) {
				o = army[i];
				if (o.IsAlive)
					if (o.command == "form_move")
						o.SetCommand("idle");
			}
		}

		if (!.InHolder)
			while (!.Stop(1000))
				;

		pt_start = .posRH;

		while (.CmdCount == 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else {
				if (.IsVisible) {//do not use the engage/advance command otherwise the entire army will fight (capturing a building may become almost impossible)
					o = .BestTargetInSquadSightMisZeroDamage;
					while (.IsValidTarget(o)) {
						go_back = false;
						while (!.GotoAttack(o, 1500, false, 15000)) {
							if (!.IsVisible)
								break;
							o = .BestTargetInSquadSightMisZeroDamage;
							if (!.IsValidTarget(o))
								break;
						}
						if (!.IsValidTarget(o))
							go_back = true;
						else if (!.IsVisible)
							go_back = true;
						if (!go_back) {
							if (o.AsCatapult().IsValid)
								while (.Attack(o)) {
									if (!.IsValidTarget(o))
										break;
									if (!.IsVisible)
										break;
									if (melee)
										if (.HasSpecial(trample))
											o.Damage(.damage);
								}
							else
								while (.Attack(o)) {
									if (!.IsValidTarget(o))
										break;
									if (!.IsVisible)
										break;
								}
							if (!.IsVisible)
								go_back = true;
							else {
								o = .BestTargetInSquadSightMisZeroDamage;
								if (!.IsValidTarget(o))
									go_back = true;
							}
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
					if (.AI)
						if (IsWaterLsa(GetGAIKA(this).LSA)) {//leave the coast
							pt = .pos;
							pt.Set(pt.x + 250 - rand(501), pt.y + 250 - rand(501));
							if (pt.InRect(GetMapRect()))
								if (IsPassable3x3(pt))
									if (!IsWaterLsa(pt.GetGAIKA().LSA)) {
										.AddCommand(true, "move", pt);
										break;
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