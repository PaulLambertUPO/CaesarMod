//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;

			if (.AI)
				.SetParryMode(false);

			if (.AsHero().IsValid)
				.AsHero().army.SetCommand("stand_position");

			if (.IsRanged)
				while (.CmdCount <= 1) {//avoid blocking pending commands forever
					while (.IsVisible) {
						o = .BestTargetForPos;
						if (!.IsValidTarget(o))
							break;
						while (.Attack(o))
							if (!.IsVisible)
								break;
					}
					if (.Stop(500))
						Sleep(500);
				}
			else {
				point pt_pos;

				pt_pos = .pos;

				while (.CmdCount <= 1) {//avoid blocking pending commands forever
					while (.IsVisible) {
						o = .BestTargetInRange(pt_pos, 150);
						if (!.IsValidTarget(o))
							break;
						if (.GotoAttack(o, 1500, true, 15000)) {
							if (!.IsVisible)
								break;
							if (.IsValidTarget(o))
								if (o.AsCatapult().IsValid)
									while (.Attack(o)) {
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
					}
					if (.pos != pt_pos) {
						if (.Goto(pt_pos, 0, 500, false, -1))
							Sleep(500);
					}
					else if (.Stop(500))
						Sleep(500);
				}
			}
		}

Sleep(30);//prevent possible loops with other commands