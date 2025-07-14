//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid) {
	Unit u;

	.AddCommand(false, "patrol", .posRH);
	.FormSetupAndMoveTo(pt, 0, 0, true);

	while (.HasPath()) {
		.FormKeepMoving(1500);
		
		u = .BestTargetInSquadSight();

		if (u.IsValid) {
			while (u.IsValid) {
				.army.SetCommand("idle");

				while (!.GotoAttack(u, 1500, false, 15000)) {
					u = .BestTargetInSquadSight();
					if (!u.IsAlive)
						break;
				}
				
				if (u.IsAlive)
					if (.IsValidTarget(u))
						while (.Attack(u))
							;

				u = .BestTargetInSquadSight();
			}											
			.FormSetupAndMoveTo(pt, 0, 0, true);
		}
	}
	Sleep(785);//this is to avoid a game freeze
}