//void, Obj h

Hero this;

this = h.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		Squad sq;
		GAIKA gk_dest, gk_in;
		Settlement set;
		bool no_enemies;

		while (true) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "ai_killall");
				.AddCommand(true, "engage");
				break;
			}

			no_enemies = true;
			sq = .GetSquad();
			gk_dest = sq.AIDest;
			gk_in = sq.GAIKAIn;

			if (gk_dest == gk_in) {
				o = .BestTargetInGAIKA;
				if (o.IsAlive) {
					no_enemies = false;
					.FormSetupAndMoveTo(o.pos, 0, 0, true);
					while (.HasPath) {
						if (o.IsDead)
							break;
						.FormKeepMoving(1500);
						if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
							.AddCommand(true, "ai_killall");
							.AddCommand(true, "engage");
							Sleep(30);//prevent possible loops with other commands
							return;
						}
					}
				}
			}

			if (no_enemies) {
				set = gk_dest.settlement;

				if (set.IsValid) {
					point pt;

					pt.Set(0, set.GetCentralBuilding().radius + rand(101));
					pt.Rot(rand(360));

					.AddCommand(true, "ai_killall");
					.AddCommand(true, "advance", set.GetCentralBuilding().pos + pt);
					break;
				}
				if (gk_dest != gk_in) {
					.AddCommand(true, "ai_killall");
					.AddCommand(true, "advance", gk_dest.Center + RandomOffset(100));
					break;
				}
			}

			Sleep(1000);
		}
	}

Sleep(30);//prevent possible loops with other commands