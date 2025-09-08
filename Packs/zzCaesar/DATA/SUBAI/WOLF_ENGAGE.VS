//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid) {
	Unit target;

	.SetSpeedFactor(125);

	target = .BestTargetInSquadSight();

	if (target.IsValid)
		while (target.IsAlive) {
			if (target.InHolder)
				return;
			if (!.IsValidTarget(target))
				return;

			while (!.GotoAttack(target, 1500, true, -1)) {
				target = .BestTargetInSquadSight();
				if (!target.IsValid)
					break;
				if (!.IsValidTarget(target))
					break;
				if (.health < .maxhealth / 2) {
					ObjList enemies;

					enemies = Intersect(ObjsInSight(this, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).GetObjList();

					if (enemies.count > 0) {//find the centre among all enemies and flee in the opposite direction
						point pt_flee;
						int i;

						for (i = 0; i < enemies.count; i += 1)
							pt_flee = pt_flee + enemies[i].pos;

						pt_flee = .pos - (pt_flee / enemies.count);
						pt_flee.SetLen(.sight * 2);
						pt_flee = (pt_flee + .pos).ClampToMap();

						if (rand(3) == 0)
							Intersect(ObjsInSight(this, "Wolf"), FriendlyObjs(.player, "Wolf")).SetCommandOffset("move", pt_flee);
						.AddCommand(true, "move", pt_flee);
						return;
					}
				}
			}

			if (target.IsValid)
				if (target.IsAlive)
					if (.IsValidTarget(target)) {
						while (.Attack(target))
							if (rand(3) == 0)
								if (.health < .maxhealth / 2) {
									ObjList enemies;

									enemies = Intersect(ObjsInSight(this, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).GetObjList();

									if (enemies.count > 0) {//find the centre among all enemies and flee in the opposite direction
										point pt_flee;
										int i;

										for (i = 0; i < enemies.count; i += 1)
											pt_flee = pt_flee + enemies[i].pos;

										pt_flee = .pos - (pt_flee / enemies.count);
										pt_flee.SetLen(.sight * 2);
										pt_flee = (pt_flee + .pos).ClampToMap();

										if (rand(3) == 0)
											Intersect(ObjsInSight(this, "Wolf"), FriendlyObjs(.player, "Wolf")).SetCommandOffset("move", pt_flee);
										.AddCommand(true, "move", pt_flee);
										return;
									}
								}
					}

			target = .BestTargetInSquadSight();
			if (!target.IsValid)
				return;
		}
}