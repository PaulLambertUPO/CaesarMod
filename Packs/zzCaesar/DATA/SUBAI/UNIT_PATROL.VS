//void, Obj This, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (!.IsHeirOf("Animal")) {//peaceful animals have strange patrol behaviours due to their animation changes in their respective scripts
		Obj enemy;

		.AddCommand(false, "patrol", .posRH);

		while (1) {
			enemy = .BestTargetInSquadSight();

			if (enemy.IsValid)
				if (.IsValidTarget(enemy)) {
					.AddCommand(true, "advance", pt);
					.AddCommand(true, "engage");
					return;
				}

			if (.Goto(pt, 0, 2000, true, -1)) {
				Sleep(500);//without this instruction, there's an infinite loop of patrol commands and the game crashes when the Goto immediately returns
				return;
			}
			if (.TimeWithoutWalking() > 0) {
				Sleep(500);
				return;
			}
		}
	}