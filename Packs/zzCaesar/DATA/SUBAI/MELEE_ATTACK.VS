//void, Obj me, Obj u

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (u.IsValid)
		if (.IsEnemy(u)) {
			Building b;

			b = u.AsBuilding();

			while (u.IsAlive()) {
				if (!.IsValidTarget(u))
					break;

				if (u.AsUnit().IsValid() || u.AsCatapult().IsValid()) {
					while (u.IsAlive() && .IsValidTarget(u))
						if (.GotoAttack(u, 5000, true, 2500))
							while (.Attack(u))
								;
				}
				else if (b.IsValid())
					while (.IsEnemy(b)) {
						bool bReady;
						if (.DistTo(b) < .sight)
							bReady = true;
						else
							bReady = .Goto(b, .sight, 5000, true, 5000);
						if (bReady) {
							if (!.IsVisible)
								.SetVisible(true);
							if (!.Attack(b))
								.Taunt(2000);
							u = .BestTargetInSquadSight();
							if (u.IsValid)
								break;
						}
					}
			}
		}