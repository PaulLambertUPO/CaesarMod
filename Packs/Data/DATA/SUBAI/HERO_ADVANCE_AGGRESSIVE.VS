//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		ObjList h_army;
		Obj o;
		point pt_dir;
		int i;

		.FormSetupAndMoveTo(pt, 0, 0, true);

		while (!.IsArmyOutside)
			.FormKeepMoving(500);

		while (.HasPath) {
			if (.IsEnemyInSquadSight) {
				if (.BestTargetInSquadSight.IsAlive) {
					.AddCommand(true, "advance_aggressive", pt);
					.AddCommand(true, "engage");
					Sleep(15);//prevent possible loops with other commands
					return;
				}
				h_army = .army;
				for (i = h_army.count - 1; i >= 0; i -= 1) {
					o = h_army[i];
					if (o.IsAlive)
						if (o.AsUnit().BestTargetInSquadSight.IsAlive) {
							.AddCommand(true, "advance_aggressive", pt);
							.AddCommand(true, "engage");
							Sleep(15);//prevent possible loops with other commands
							return;
						}
				}
			}
			.FormKeepMoving(1500);
		}

		pt_dir = .GetFinalPartyOrientation() - Point(1024, 1024);

		if (pt_dir.x != 0)
			.Face(.pos + pt_dir);
		else if (pt_dir.y != 0)
			.Face(.pos + pt_dir);
	}

Sleep(15);//prevent possible loops with other commands