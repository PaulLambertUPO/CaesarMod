//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			bool melee;

			if (.AI)
				.SetParryMode(false);

			if (.AsHero().IsValid)
				.AsHero().army.SetCommand("hold_position");

			melee = !.IsRanged;

			while (.CmdCount <= 1) {//avoid blocking pending commands forever
				while (.IsVisible) {
					o = .BestTargetForPos;
					if (!.IsValidTarget(o))
						break;
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
				if (.Stop(500))
					Sleep(500);
			}
		}

Sleep(30);//prevent possible loops with other commands