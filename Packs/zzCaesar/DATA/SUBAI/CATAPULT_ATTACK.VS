//void, Obj me, Obj target

Catapult this;

this = me.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (target.IsValid) {
				Settlement set;
				Building target_bld;
				point pt_attack;
				bool target_is_building, rotated = false;

				set = .settlement;

				target_bld = target.AsBuilding();
				target_is_building = target_bld.IsValid;

				.SetTarget(target);

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

					if (target.IsDead)
						break;
					if (!.IsEnemy(target))
						break;
					if (!.IsValidTarget(target))
						break;
					if (target_is_building)
						if (target_bld.IsVeryBroken) {
							if (!target_bld.IsCentralBuliding)
								break;
							if (target_bld.settlement.UnitsCount <= 0)
								break;
						}

					pt_attack = .GetPointOnTarget(target);
					if (!.InRange(pt_attack))
						break;
					pt_attack = GetCatapultAttackPoint(pt_attack);

					if (!rotated) {
						.RotateTo(pt_attack);
						rotated = target_is_building;//units will probably move around the catapult
						if (.IsDead)
							break;
						if (.CmdCount > 1)
							break;
						if (set.UnitsCount <= 0)
							break;
					}

					.Attack(pt_attack);
				}

				.ClearTarget();
			}