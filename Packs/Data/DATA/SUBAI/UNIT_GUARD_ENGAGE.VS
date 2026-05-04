//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			bool melee;

			melee = !.IsRanged;

			.SetParryMode(false);

			o = .BestTargetInSquadSightMisZeroDamage;

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

				o = .BestTargetInSquadSightMisZeroDamage;
			}
		}

Sleep(30);//prevent possible loops with other commands