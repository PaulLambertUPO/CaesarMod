//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			bool melee;

			if (IsAIPlayer(.player))
				.SetParryMode(false);

			melee = !.IsRanged;

			if (.AsHero().IsValid)
				.AsHero().army.SetCommand("hold_position");

			while (.CmdCount <= 1) {//avoid blocking pending commands forever
				if (.IsVisible) {
					o = .BestTargetForPos;
					while (.IsValidTarget(o)) {
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
							break;
						o = .BestTargetForPos;
					}
				}
				if (.Stop(2000))
					Sleep(500);
			}
		}

Sleep(15);//prevent possible loops with other commands