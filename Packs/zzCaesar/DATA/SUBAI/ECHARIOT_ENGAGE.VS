//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj o;
			int i, disease_cost;

			Sleep(rand(151));//avoid "thundering herd" for multiple units start the command simultaneously

			if (IsAIPlayer(.player))
				.SetParryMode(false);

			disease_cost = GetConst("DiseaseCost");

			if (.stamina >= disease_cost)
				o = .BestTargetInSquadSight_PreferUndiseased();
			else
				o = .BestTargetInSquadSight;

			while (.IsValidTarget(o)) {
				if (.GotoAttack(o, 1500, true, 15000))
					if (.IsValidTarget(o))
						if (o.AsUnit().IsValid) {
							if (.stamina >= disease_cost)
								if (o.AsUnit().IsDiseased)
									i = 1;
								else
									i = 2;
							else
								i = 4;
							while (i > 0) {
								if (!.Attack(o))
									break;
								i -= 1;
							}
						}
						else
							while (.Attack(o))
								;
				if (.stamina >= disease_cost)
					o = .BestTargetInSquadSight_PreferUndiseased();
				else
					o = .BestTargetInSquadSight();
			}
		}

Sleep(15);//prevent possible loops with other commands