//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (!.IsHeirOf("Animal")) {//peaceful animals have strange patrol behaviours due to their animation changes in their respective scripts
		Unit u;
		bool u_is_valid;

		.AddCommand(false, "patrol", .posRH);

		while (1) {
			u_is_valid = false;
			u = .BestTargetInSquadSight();

			if (u.IsValid)
				if (u.IsAlive)
					if (.IsValidTarget(u))
						u_is_valid = true;

			if (u_is_valid) {
				.AddCommand(true, "patrol", pt);
				.AddCommand(true, "engage");
				return;
			}
			else {
				if (.Goto (pt, 0, 2000, true, -1)) {
					Sleep(500);//without this instruction, there's an infinite loop of patrol commands and the game crashes when the Goto immediately returns
					return;
				}
				if (.TimeWithoutWalking() > 0) {
					Sleep(500);
					return;
				}
			}
		}
	}