//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid) {
	Obj enemy;
	Unit u;
	int i, disease_cost;

	disease_cost = GetConst("DiseaseCost");

	if (.stamina >= disease_cost)
		enemy = .BestTargetInSquadSight_PreferUndiseased();
	else
		enemy = .BestTargetInSquadSight();

	while (enemy.IsValid) {
		Sleep(20 + rand(31));//disperse the times

		if (!enemy.IsAlive)
			break;
		if (!.IsEnemy(enemy))
			break;
		if (!.IsValidTarget(enemy))
			break;

		while (!.GotoAttack(enemy, 1500, true, 15000)) {
			if (.stamina >= disease_cost)
				enemy = .BestTargetInSquadSight_PreferUndiseased();
			else
				enemy = .BestTargetInSquadSight();
			if (!enemy.IsValid)
				break;
			if (!.IsValidTarget(enemy))
				break;
		}

		if (enemy.IsValid)
			if (enemy.IsAlive)
				if (.IsEnemy(enemy))
					if (.IsValidTarget(enemy)) {
						u = enemy.AsUnit();
						if (u.IsValid) {
							if (!u.InHolder) {
								if (.stamina >= disease_cost)
									if (u.IsDiseased)
										i = 1;
									else
										i = 2;
								else
									i = 4;
								while (i > 0) {
									if (!.Attack(enemy))
										break;
									i -= 1;
								}
							}
						}
						else if (enemy.AsCatapult().IsValid)
							while (.Attack(enemy))
								;
					}

		if (.stamina >= disease_cost)
			enemy = .BestTargetInSquadSight_PreferUndiseased();
		else
			enemy = .BestTargetInSquadSight();
	}
}
Sleep(15);