//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			Obj target;

			.SetSpeedFactor(110);

			target = .BestTargetInSquadSight;

			while (.IsValidTarget(target)) {
				while (!.GotoAttack(target, 1500, false, -1)) {
					target = .BestTargetInSquadSight;
					if (!.IsValidTarget(target))
						break;
					if (.health < .maxhealth / 2) {
						ObjList enemies;

						enemies = Intersect(ObjsInSight(this, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).GetObjList();

						if (enemies.count > 0) {//find the centre among all enemies and flee in the opposite direction
							point pt_flee;
							int i;

							for (i = enemies.count - 1; i >= 0; i -= 1)
								pt_flee = pt_flee + enemies[i].pos;

							pt_flee = .pos - (pt_flee / enemies.count);
							pt_flee.SetLen(.sight * 2);
							pt_flee = (pt_flee + .pos).ClampToMap();

							if (rand(3) == 0)
								Intersect(ObjsInSight(this, "LionM,LionF"), Union(FriendlyObjs(.player, "LionM"), FriendlyObjs(.player, "LionF"))).SetCommandOffset("move", pt_flee);
							.AddCommand(true, "move", pt_flee);
							Sleep(15);//prevent possible loops with other commands
							return;
						}
					}
				}

				if (.IsValidTarget(target)) {
					bool target_catapult;

					target_catapult = target.AsCatapult().IsValid;

					while (.Attack(target)) {
						if (target_catapult)
							if (.HasSpecial(trample))
								target.Damage(.damage);
						if (rand(8) == 0)
							if (.health < .maxhealth / 2) {
								ObjList enemies;

								enemies = Intersect(ObjsInSight(this, "Military,FakeTower"), Union(EnemyObjs(.player, "Military"), EnemyObjs(.player, "FakeTower"))).GetObjList();

								if (enemies.count > 0) {//find the centre among all enemies and flee in the opposite direction
									point pt_flee;
									int i;

									for (i = enemies.count - 1; i >= 0; i -= 1)
										pt_flee = pt_flee + enemies[i].pos;

									pt_flee = .pos - (pt_flee / enemies.count);
									pt_flee.SetLen(.sight * 2);
									pt_flee = (pt_flee + .pos).ClampToMap();

									if (rand(4) == 0)
										Intersect(ObjsInSight(this, "LionM,LionF"), Union(FriendlyObjs(.player, "LionM"), FriendlyObjs(.player, "LionF"))).SetCommandOffset("move", pt_flee);
									.AddCommand(true, "move", pt_flee);
									Sleep(15);//prevent possible loops with other commands
									return;
								}
							}
					}
				}

				target = .BestTargetInSquadSight;
			}
		}

Sleep(15);//prevent possible loops with other commands