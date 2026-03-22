//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Settlement set;
		point pt;

		while (.CmdCount == 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(2500);
			else if (.Stop(2000)) {
				if (.AI)
					if (!.hero.IsValid)
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

Sleep(15);//prevent possible loops with other commands