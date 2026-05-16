//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			bool melee;

			Sleep(rand(151));//avoid "thundering herd" for multiple units that start the command simultaneously

			melee = !.IsRanged;

			if (.AI)
				.SetParryMode(false);

			o = .BestTargetInSquadSight;

			while (.IsValidTarget(o)) {
				if (.GotoAttack(o, 1500, true, 15000))
					if (.IsValidTarget(o))
						if (o.AsCatapult().IsValid) {
							while (.Attack(o))
								if (melee)
									if (.HasSpecial(trample))
										o.Damage(.damage);
						}
						else
							while (.Attack(o))
								;
				o = .BestTargetInSquadSight;
			}
		}

Sleep(30);//prevent possible loops with other commands