//void, Obj This

Druid this;
int hide_stamina_cost;

this = This.AsDruid();
hide_stamina_cost = GetCmdStaminaCost("hide");

Sleep(1000 + rand(200));

while (!IsResearched(.player, "Mass Concealment"))
	Sleep(2000 + rand(1000));

while (.HasSpecial(invisibility)) {
	if (!.InHolder)
		if (.stamina >= hide_stamina_cost) {
			str prev_cmd;
			prev_cmd = .command;
			if (prev_cmd == "idle" || prev_cmd == "stand_position" || prev_cmd == "hold_position") {
				ObjList ol;
				Unit u;
				int i;

				if (.IsVisible()) {
					.SetCommand("hide", this);
					if (prev_cmd != "idle")
						.AddCommand(false, prev_cmd);//avoid moving the druid if he was ordered to stand still
				}

				ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(.player, "Military")).GetObjList();

				for (i = 0; i < ol.count; i += 1) {
					if (.stamina < hide_stamina_cost)
						break;
					u = ol[i].AsUnit();
					if (u.IsValid)
						if (u.IsAlive)
							if (u.player == .player)
								if (u.IsVisible)
									if (!u.EnemiesInSight)
										if (u.command != "capture")
											if (u.command != "attack")
												if (!u.IsSentry)
													if (!u.IsHeirOf("ShipBattle"))
														if (prev_cmd == "idle")
															.SetCommand("hide", u);
														else if (.InRange(u))
															.SetCommand("hide", u);
				}
				if (prev_cmd != "idle")
					.AddCommand(false, prev_cmd);//avoid moving the druid if he was ordered to stand still
			}
		}
	Sleep(1000);
}

Sleep(500);