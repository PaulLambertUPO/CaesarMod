//void, Obj u

Unit this;

this = u.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		Squad sq;
		GAIKA gk_dest, gk_in;
		Settlement set;
		bool melee, sq_to_get;

		.SetParryMode(false);

		melee = !.IsRanged;

		while (true) {
			sq_to_get = true;

			o = .BestTargetInSquadSightMisZeroDamage;
			if (o.IsDead) {
				sq = .GetSquad();
				gk_dest = sq.AIDest;
				gk_in = sq.GAIKAIn;
				if (sq.AIDest == sq.GAIKAIn)
					o = .BestTargetInGAIKA;
				sq_to_get = false;
			}
			if (o.IsAlive) {
				if (.GotoAttack(o, 1500, true, 15000))
					if (o.AsCatapult().IsValid) {
						while (.Attack(o))
							if (melee)
								if (.HasSpecial(trample))
									o.Damage(.damage);
					}
					else
						while (.Attack(o))
							;
				continue;
			}

			if (sq_to_get) {
				sq = .GetSquad();
				gk_dest = sq.AIDest;
				gk_in = sq.GAIKAIn;
			}

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

			Sleep(1000);
		}
	}

Sleep(30);//prevent possible loops with other commands