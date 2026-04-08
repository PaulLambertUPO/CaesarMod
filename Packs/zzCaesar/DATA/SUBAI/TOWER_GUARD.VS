//void, Obj This

Tower this;

this = This.AsTower();

if (.IsValid) {
	Settlement set;
	Unit target;

	set = .settlement;

	while (true) {
		if (set.IsOutpost)
			while (set.IsIndependent)
				Sleep(1000);

		target = .GetUITarget();

		if (.IsValidTarget(target))
			if (.CanAttack(target))
				while (.Attack(target)) {
					Sleep(500);
					if (!.IsValidTarget(target))
						break;
					if (!.CanAttack(target))
						break;
				}

		target = .BestTarget;

		if (.IsValidTarget(target))
			if (.CanAttack(target))
				while (.Attack(target)) {
					Sleep(500);
					if (!.IsValidTarget(target))
						break;
					if (!.CanAttack(target))
						break;
				}

		Sleep(500);
	}
}