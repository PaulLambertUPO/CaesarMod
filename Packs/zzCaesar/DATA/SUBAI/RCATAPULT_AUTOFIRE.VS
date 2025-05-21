//void, Obj This

Catapult this;
Obj target;
bool change_target;

this = This.AsCatapult();

if (.IsValid)
	while (.IsAlive) {
		if (.CmdCount() > 1)
			break;
		if (.settlement.UnitsCount <= 0)
			break;

		target = .GetCurrentTarget();
		.SetTarget(target);
		change_target = false;

		if (!target.IsValid)
			change_target = true;
		else if (!target.IsAlive)
			change_target = true;
		else if (!.IsEnemy(target))
			change_target = true;
		else if (!.IsValidTarget(target))
			change_target = true;
		else if (!.InRange(target.pos))
			change_target = true;
		else {
			Building bld;
			bld = target.AsBuilding();
			if (bld.IsValid)
				if (bld.IsVeryBroken)
					if (!bld.IsCentralBuliding())
						change_target = true;
					else if (bld.settlement.UnitsCount <= 0)
						change_target = true;
		}

		if (change_target) {
			target = .BestTarget();
			if (target.IsValid)
				.SetTarget(target);
		}

		Sleep(1000);
	}