//void, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (.HasFinalPartyOrientationRequest)
			.AddCommand(true, "move", pt);
		else {
			Obj o;
			int start_time;
			bool melee;

			while (!.Goto(pt, 0, 2000, false, 0))
				;

			start_time = GetTime();
			melee = !.IsRanged;

			while (true) {
				o = .BestTargetForPos;

				if (.IsValidTarget(o))
					if (o.AsCatapult().IsValid) {
						while (.Attack(o))
							if (melee)
								if (.HasSpecial(trample))
									o.Damage(.damage);
					}
					else
						while (.Attack(o))
							;

				Sleep(500);

				if (GetTime() > start_time + 10000)
					break;
			}
		}

Sleep(30);//prevent possible loops with other commands