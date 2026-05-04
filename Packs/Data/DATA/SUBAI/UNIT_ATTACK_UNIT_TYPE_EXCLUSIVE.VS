//void, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		if (.AI)
			.SetParryMode(false);

		u = target.AsUnit();

		if (u.IsValid) {
			while (.IsValidTarget(u)) {
				if (u.InHolder)
					break;
				if (.GotoAttack(u, 1500, true, 3000))
					if (.IsValidTarget(u))
						while (.Attack(u))
							;
			}
			.AddCommand(true, "engage_unit_type_exclusive", target);//using u is not good because it might be invalid after the loop
		}
		else
			.AddCommand(true, "engage");
	}

Sleep(30);//prevent possible loops with other commands