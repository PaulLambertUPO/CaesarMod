//void, Obj me, Obj wall_gate

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Obj target;
		point dir_gate, dir_sentry;
		int i;

		dir_gate = wall_gate.AsBuilding().GetPoint(8, 0);
		dir_sentry = dir_gate;

		while (1) {
			target = .BestTargetForPos;
			if (.IsValidTarget(target)) {
				dir_sentry = dir_gate;
				i = 0;
				while (.IsValidTarget(target)) {
					if (!.InRange(target))
						break;
					.Attack(target);
				}
			}

			.Stop(1000);
			.Face(.pos - dir_sentry);
			if (i < 10) {
				dir_sentry = dir_sentry + Point(rand(51) - 25, rand(51) - 25);
				i += 1;
			}
			else {
				dir_sentry = dir_gate;
				i = 0;
			}

			Sleep(400 + rand(101));
		}
	}