//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			bool this_ai, melee;

			Sleep(rand(151));//avoid "thundering herd" for multiple units that start the command simultaneously

			this_ai = .AI;
			melee = !.IsRanged;

			if (this_ai) {
				.SetParryMode(false);
				if (rand(3) == 0)
					o = .BestTargetInSquadSight;
				else
					o = .BestTargetInSquadSightMisZeroDamage;
			}
			else
				o = .BestTargetInSquadSight;

			while (.IsValidTarget(o)) {
				if (.GotoAttack(o, 1500, true, 15000))
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

				if (this_ai)
					if (rand(3) == 0)
						o = .BestTargetInSquadSight;
					else
						o = .BestTargetInSquadSightMisZeroDamage;
				else
					o = .BestTargetInSquadSight;
			}
		}

Sleep(30);//prevent possible loops with other commands