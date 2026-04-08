//void, Obj h

Hero this;

this = h.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		Squad sq;
		GAIKA gk_dest;
		Settlement set;
		bool no_enemies, sq_to_get;

		while (true) {
			if (.BestTargetInSquadSightMisZeroDamage.IsAlive) {
				.AddCommand(true, "ai_killall");
				.AddCommand(true, "engage");
				break;
			}

			sq = .GetSquad();
			no_enemies = true;
			sq_to_get = false;

			if (sq.AIDest == sq.GAIKAIn) {
				o = .BestTargetInGAIKA;
				if (o.IsAlive) {
					no_enemies = false;
					sq_to_get = true;
					.FormSetupAndMoveTo(o, 0, 0, true);
					while (o.IsAlive) {
						if (!.HasPath)
							break;
						if (.DistTo(o) < .sight + 100)
							break;
						.FormKeepMoving(1500);
						if (.BestTargetInSquadSightMisZeroDamage != o)
							break;
					}
				}
			}

			if (no_enemies) {
				if (sq_to_get)
					sq = .GetSquad();

				gk_dest = sq.AIDest;
				set = gk_dest.settlement;

				if (set.IsValid) {
					.AddCommand(true, "ai_killall");
					.AddCommand(true, "advance", set.GetCentralBuilding().pos);
					break;
				}
				if (gk_dest != sq.GAIKAIn) {
					.AddCommand(true, "ai_killall");
					.AddCommand(true, "advance", gk_dest.Center);
					break;
				}
			}

			Sleep(1000);
		}
	}

Sleep(15);//prevent possible loops with other commands