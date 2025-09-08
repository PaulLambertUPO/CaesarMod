//void, Obj me, point pt

Catapult this;

this = me.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (.InRange(pt)) {
				Settlement set;
				bool rotated = false;

				set = .settlement;

				.ClearTarget();

				while (.IsAlive) {
					if (.CmdCount > 1)
						break;
					if (set.UnitsCount <= 0)
						break;

					Sleep(.AttackWait);

					if (.IsDead)
						break;
					if (.CmdCount > 1)
						break;
					if (set.UnitsCount <= 0)
						break;

					if (!rotated) {
						.RotateTo(pt);
						rotated = true;
						if (.IsDead)
							break;
						if (.CmdCount > 1)
							break;
						if (set.UnitsCount <= 0)
							break;
					}

					.Attack(GetCatapultAttackPoint(pt));
				}
			}