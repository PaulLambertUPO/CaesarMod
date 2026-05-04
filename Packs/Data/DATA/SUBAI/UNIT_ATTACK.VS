//void, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (.AI)
			.SetParryMode(false);

		if (target.IsAlive) {
			Unit u;
			bool melee;

			melee = !.IsRanged;
			u = target.AsUnit();

			while (.IsValidTarget(target)) {
				if (u.IsValid)
					if (u.InHolder)
						break;
				if (.GotoAttack(target, 1500, true, 3000))
					if (.IsValidTarget(target))
						if (target.AsCatapult().IsValid) {
							while (.Attack(target))
								if (melee)
									if (.HasSpecial(trample))
										target.Damage(.damage);
						}
						else
							while (.Attack(target))
								;
			}
		}

		.AddCommand(true, "engage");
	}

Sleep(30);//prevent possible loops with other commands