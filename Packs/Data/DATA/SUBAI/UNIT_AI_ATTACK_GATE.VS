//void, Obj u, Obj g

if (g.AsGate().IsValid) {
	Unit this;

	this = u.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (.IsValidTarget(g)) {
				.SetParryMode(false);

				while (!.GotoAttack(g, 2000, true, 2500))
					;

				{
					Obj o;

					while (true) {
						o = .BestTargetInSquadSightMisZeroDamage;
						if (.IsValidTarget(o)) {
							if (!.Attack(o))
								if (!.Attack(g))
									Sleep(2000);
						}
						else if (!.Attack(g))
							Sleep(2000);
					}
				}
			}
}

Sleep(15);//prevent possible loops with other commands