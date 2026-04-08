//void, Obj u

Unit this;

this = u.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Obj o;
		Squad sq;
		GAIKA gk_dest;
		Settlement set;
		bool melee, sq_to_get;

		.SetParryMode(false);

		melee = !.IsRanged;

		while (true) {
			sq_to_get = true;

			o = .BestTargetInSquadSightMisZeroDamage;
			if (o.IsDead) {
				sq = .GetSquad();
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

			Sleep(1000);
		}
	}

Sleep(15);//prevent possible loops with other commands