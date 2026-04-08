//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			point pt_pos;
			int rng;
			bool melee;

			if (IsAIPlayer(.player))
				.SetParryMode(false);

			pt_pos = .pos;

			if (.IsRanged) {
				rng = .range;
				melee = false;
			}
			else {
				rng = 120;
				melee = true;
			}

			if (.AsHero().IsValid)
				.AsHero().army.SetCommand("stand_position");

			while (.CmdCount <= 1) {//avoid blocking pending commands forever
				if (.IsVisible) {
					o = .BestTargetInRange(pt_pos, rng);
					while (.IsValidTarget(o)) {
						if (.GotoAttack(o, 1500, true, 15000)) {
							if (!.IsVisible)
								break;
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
						}
						if (!.IsVisible)
							break;
						o = .BestTargetInRange(pt_pos, rng);
					}
				}
				if (.Goto(pt_pos, 0, 500, false, -1))
					if (.Stop(2000))
						Sleep(500);
			}
		}

Sleep(15);//prevent possible loops with other commands