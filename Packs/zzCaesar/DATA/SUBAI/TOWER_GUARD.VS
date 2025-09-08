//void, Obj me

Tower this;

this = me.AsTower();

if (.IsValid) {
	Settlement set;
	Unit target;

	set = .settlement;

	while (1) {
		if (set.IsOutpost)
			while (set.IsIndependent)
				Sleep(500);

		target = .GetUITarget();

		if (target.IsValid)
			if (target.IsAlive)
				if (.IsValidTarget(target))
					if (.CanAttack(target))
						while (.Attack(target)) {
							Sleep(500);

							if (target.IsDead)
								break;
							if (!.IsValidTarget(target))
								break;
							if (!.CanAttack(target))
								break;
						}

		target = .BestTarget;

		if (target.IsValid)
			if (target.IsAlive)
				if (.IsValidTarget(target))
					if (.CanAttack(target))
						while (.Attack(target)) {
							Sleep(500);

							if (target.IsDead)
								break;
							if (!.IsValidTarget(target))
								break;
							if (!.CanAttack(target))
								break;
						}

		Sleep(500);
	}
}