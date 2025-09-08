//void, Obj me

Tower this;

this = me.AsTower();

if (.IsValid) {
	Obj target;

	while (1) {
		target = .GetUITarget();

		if (target.IsValid)
			if (target.IsAlive)
				if (.IsValidTarget(target))
					if (.CanAttack(target)) 
						while (.Attack(target)) {
							Sleep(500);

							target = .GetUITarget();

							if (!target.IsValid)
								break;
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