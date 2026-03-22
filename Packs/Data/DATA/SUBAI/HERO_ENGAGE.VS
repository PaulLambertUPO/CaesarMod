//void, Obj This

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (!.InHolder) {
			ObjList h_army;
			Obj o;
			int i;
			bool melee, enemy_to_fight = true;

			melee = !.IsRanged;

			{
				str cmd;

				h_army = .army;
				for (i = h_army.count - 1; i >= 0; i -= 1) {
					o = h_army[i];
					if (o.IsAlive) {
						cmd = o.command;
						if (cmd != "engage")
							if (cmd != "attack")
								if (cmd != "engage_unit_type_exclusive")
									if (cmd != "attack_unit_type_exclusive")
										o.SetCommand("engage");
					}
				}
			}

			while (enemy_to_fight) {
				enemy_to_fight = false;

				if (.IsEnemyInSquadSight) {
					o = .BestTargetInSquadSight;
					if (.IsValidTarget(o))
						enemy_to_fight = true;
					else {
						h_army = .army;
						for (i = h_army.count - 1; i >= 0; i -= 1) {
							o = h_army[i];
							if (o.IsAlive) {
								o = o.AsUnit().BestTargetInSquadSight;
								if (o.IsAlive) {
									enemy_to_fight = true;
									break;
								}
							}
						}
					}
				}
				else
					break;

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

					o = .BestTargetInSquadSight;
				}

				.Stop(500);

				Sleep(500);
			}
		}

Sleep(15);//prevent possible loops with other commands