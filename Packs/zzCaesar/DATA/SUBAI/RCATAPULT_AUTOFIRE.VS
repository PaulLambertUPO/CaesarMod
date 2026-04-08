//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt) {
			Settlement set;
			Obj target;
			Building target_bld;
			bool change_target;

			set = .settlement;

			while (.IsAlive) {
				if (.CmdCount > 1)
					break;
				if (set.UnitsCount <= 0)
					break;

				target = .GetCurrentTarget();

				.SetTarget(target);//set the target of the fake tower (CatapultTower class)

				change_target = false;

				if (target.IsDead)
					change_target = true;
				else if (!.IsEnemy(target))
					change_target = true;
				else if (!.IsValidTarget(target))
					change_target = true;
				else if (!.InRange(target.pos))
					change_target = true;
				else {
					target_bld = target.AsBuilding();
					if (target_bld.IsValid)
						if (target_bld.IsVeryBroken)
							if (!target_bld.IsCentralBuliding)
								change_target = true;
							else if (target_bld.settlement.UnitsCount <= 0)
								change_target = true;
				}

				if (change_target) {
					target = .BestTarget();
					if (target.IsValid)
						.SetTarget(target);
				}

				Sleep(1000);
			}
		}