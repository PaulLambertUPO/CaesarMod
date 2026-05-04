//void, Obj This, Obj target

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (!.InHolder) {
			Unit u;

			if (.AI)
				.SetParryMode(false);

			u = target.AsUnit();

			if (u.IsValid) {
				str u_class;

				u_class = u.class;

				u = .BestTargetInSquadSightExclusive(u_class).AsUnit();

				while (.IsValidTarget(u)) {
					if (.GotoAttack(u, 1500, true, 15000))
						if (.IsValidTarget(u))
							while (.Attack(u))
								;
					u = .BestTargetInSquadSightExclusive(u_class).AsUnit();
				}
			}
		}

		.AddCommand(true, "engage");
	}

Sleep(30);//prevent possible loops with other commands