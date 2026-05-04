//void, Obj This, Obj target

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		if (!.InHolder) {
			Unit u;

			u = target.AsUnit();

			if (u.IsValid) {
				str u_class;

				{
					ObjList h_army;
					Obj o;
					int i;

					h_army = .army;
					for (i = h_army.count - 1; i >= 0; i -= 1) {
						o = h_army[i];
						if (o.IsAlive)
							if (o.command != "engage_unit_type_exclusive")
								o.SetCommand("engage_unit_type_exclusive", u);
					}
				}

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