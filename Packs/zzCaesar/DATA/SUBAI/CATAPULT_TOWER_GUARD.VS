//void, Obj me

Tower this;

this = me.AsTower();

if (.IsValid) {
	Obj target;

	while (true) {
		target = .GetUITarget();

		if (.IsValidTarget(target))
			if (.CanAttack(target)) 
				while (.Attack(target)) {
					Sleep(500);

					target = .GetUITarget();

					if (!.IsValidTarget(target))
						break;
					if (!.CanAttack(target))
						break;
				}

		Sleep(500);
	}
}