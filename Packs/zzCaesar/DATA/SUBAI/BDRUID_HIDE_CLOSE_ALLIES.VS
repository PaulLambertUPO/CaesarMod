//void, Obj This

Druid this;

this = This.AsDruid();

Sleep(rand(151) + 150);

if (.IsValid) {
	ObjList ol;
	Unit u;
	str prev_cmd;
	int hide_stamina_cost, i;

	hide_stamina_cost = GetCmdStaminaCost("hide");

	while (.IsAlive) {
		if (.HasSpecial(invisibility))//just a security check in case the special is removed by an adventure sequence
			if (!.InHolder)
				if (.stamina >= hide_stamina_cost)
					if (IsResearched(.player, "Mass Concealment")) {
						prev_cmd = .command;
						if (prev_cmd == "idle" || prev_cmd == "stand_position" || prev_cmd == "hold_position") {
							if (.IsVisible)
								.SetCommand("hide", this);
							else {
								if (prev_cmd == "idle")
									ol = Intersect(VisibleObjsInSight(this, "Military"), FriendlyObjs(.player, "Military")).GetObjList();
								else
									ol = Intersect(ObjsInRange(this, "Military", .range), FriendlyObjs(.player, "Military")).GetObjList();
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
															if (u.command != "engage")
																if (u.command != "attack")
																	if (!u.IsSentry)
																		if (!u.IsHeirOf("ShipBattle"))
																			if (prev_cmd == "idle") {
																				.SetCommand("hide", u);
																				break;
																			}
																			else if (.InRange(u)) {
																				.SetCommand("hide", u);
																				break;
																			}
								}
							}
							if (prev_cmd != "idle")
								.AddCommand(false, prev_cmd);//avoid moving the druid if he was ordered to stand still
						}
					}
		Sleep(2000);
	}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);