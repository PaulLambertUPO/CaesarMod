//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid) {
	Obj enemy;
	bool melee;

	melee = !.IsRanged;

	.AddCommand(false, "patrol", .posRH);
	.FormSetupAndMoveTo(pt, 0, 0, true);

	while (.HasPath()) {
		.FormKeepMoving(1500);

		enemy = .BestTargetInSquadSight();

		if (enemy.IsValid) {
			while (enemy.IsValid) {
				.army.SetCommand("engage");

				while (!.GotoAttack(enemy, 1500, false, 15000)) {
					enemy = .BestTargetInSquadSight();
					if (!enemy.IsValid)
						break;
					if (!.IsValidTarget(enemy))
						break;
				}

				if (enemy.IsValid)
					if (enemy.IsAlive)
						if (.IsEnemy(enemy))
							if (.IsValidTarget(enemy))
								if (enemy.AsCatapult().IsValid) {
									while (.Attack(enemy))
										if (melee)
											if (.HasSpecial(trample))
												enemy.Damage(.damage);
								}
								else if (enemy.AsUnit().IsValid)
									if (!enemy.AsUnit().InHolder)
										while (.Attack(enemy))
											;

				enemy = .BestTargetInSquadSight();
			}
			.FormSetupAndMoveTo(pt, 0, 0, true);
		}
	}

	Sleep(785);//this is to avoid a game freeze
}