//void, Obj This, point pt

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (.InRange(pt)) {
				Settlement set;
				bool rotate = true;

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

					if (rotate) {
						.RotateTo(pt);
						rotate = false;
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