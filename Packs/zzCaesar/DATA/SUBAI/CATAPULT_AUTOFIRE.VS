//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt) {
			Settlement set;
			Obj target;

			set = .settlement;

			while (.IsAlive) {
				if (.CmdCount > 1)
					break;
				if (set.UnitsCount <= 0)
					break;

				target = .GetCurrentTarget();
				if (!target.IsValid)
					target = .BestTarget();

				if (target.IsValid) {
					Building target_bld;
					point pt_attack;
					bool target_is_building, rotate = true;

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

						if (rotate) {
							.RotateTo(pt_attack);
							if (target_is_building)//units will probably move around the catapult
								rotate = false;
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

				Sleep(1000);
			}
		}