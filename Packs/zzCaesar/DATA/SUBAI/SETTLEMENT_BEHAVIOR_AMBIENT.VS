//void, Obj This

Sleep(1500 + rand(1501));

if (This.AsBuilding().IsValid)
	if (MapSize < 32000)
		if (!IsMultiplayer) {
			Settlement this;
			Building bld_1, bld_2, bld_damaged;
			ObjList peasants;
			Unit u, u_talk;
			StrArray villager_classes;
			point pt_pos, pt_1, pt_2;
			int i, j, c, plr, prev_pop, alive_or_dead_pop, total_peasants, hide_timer, pop_timer = 10000;
			bool found_idle_peasant, hide_peasants = false;

			this = This.AsBuilding().settlement;

			bld_1 = .GetCentralBuilding();

			pt_pos = bld_1.pos;

			plr = .player;
			prev_pop = .population;

			if (bld_1.race == ImperialRome) {
				villager_classes[0] = "HVillagerAmbient";
				villager_classes[1] = "HWVillagerAmbient";
			}
			else {
				villager_classes[0] = bld_1.raceStrPref + "VillagerAmbient";
				villager_classes[1] = bld_1.raceStrPref + "WVillagerAmbient";
			}

			if (.IsVillage) {
				if (bld_1.race == Carthage)
					villager_classes[2] = "OldManAAmbient";
				else if (bld_1.race == Egypt)
					villager_classes[2] = "OldManAAmbient";
				else
					villager_classes[2] = "OldManEAmbient";
				for (i = rand(5) + 4; i > 0; i -= 1)//place up to 8 hens
					for (j = 0; j < 5; j += 1) {
						pt_1 = pt_pos + RandomOffset(600);
						if (IsPassable3x3(pt_1)) {
							u = Place("Hen", pt_1, 15).AsUnit();
							if (u.IsValid) {
								u.SetNoAIFlag(true);
								u.SetNoselectFlag(true);
								u.SetMinimapFlag(true);
								break;
							}
						}
					}
			}
			c = villager_classes.size;

			while (true) {
				peasants.ClearDead();

				if (plr != .player) {
					plr = .player;
					peasants.SetPlayer(plr);
				}

				alive_or_dead_pop = .population;
				if (pop_timer <= 0) {
					total_peasants = MIN(6, alive_or_dead_pop / 10);
					if (total_peasants <= 0)
						if (alive_or_dead_pop > 0)
							total_peasants = 1;
					if (rand(5) < 2)
						total_peasants = 2;
					if (rand(10) == 0)
						total_peasants = 0;
					pop_timer = 10000;
				}

				bld_damaged = .MostDamagedBuilding;

				//if there is either the disabled flag or a damaged building or an enemy around, peasants go away, otherwise they talk/work/walk
				if (EnvReadInt(this, "no_villagers") == 1)//used in "The siege of Numantia" and "Boudicca's rebellion" adventures
					hide_timer = 5000;
				else if (bld_damaged.IsValid) {
					bld_damaged.ClearDamageTaken();
					hide_timer = 5000;
				}
				else if (!Subtract(Intersect(ObjsInCircle(pt_pos, 900, "Unit"), EnemyObjs(plr, "Unit")), EnemyObjs(plr, "Hen")).IsEmpty)
					hide_timer = 5000;

				if (hide_timer > 0) {
					if (!hide_peasants) {
						hide_peasants = true;
						for (i = peasants.count - 1; i >= 0; i -= 1) {
							u = peasants[i].AsUnit();
							if (u.IsAlive)
								if (u.command == "disappear")
									u.Erase();
								else {
									pt_1 = u.pos;
									if (pt_1.x == -1)
										u.Erase();
									else if (pt_1.y == -1)
										u.Erase();
									else {
										u.SetCommand("moveenter", .FindNearEnterExit(pt_1));
										u.AddCommand(false, "dismiss");
									}
								}
						}
					}
					for (alive_or_dead_pop = .PopulationDied; prev_pop < alive_or_dead_pop; prev_pop += 1)
						if (rand(5) < 2) {
							if (bld_damaged.IsValid)
								pt_1 = bld_damaged.GetEnterExit();
							else
								pt_1.Set(-1, -1);
							bld_1 = bld_damaged;
							if (pt_1.x == -1)
								if (pt_1.y == -1) {
									bld_1 = .GetEnterExit();
									if (bld_1.IsValid)
										pt_1 = bld_1.GetEnterExit();
								}
							if (bld_1.IsValid)
								if (pt_1.x != -1)
									if (pt_1.y != -1) {
										pt_2 = pt_1 * 2 - bld_1.pos + RandomOffset(50);
										u = Place(villager_classes[rand(c)], pt_1, plr).AsUnit();
										if (u.IsValid) {
											u.SetNoAIFlag(true);
											u.SetNoselectFlag(true);
											u.SetMinimapFlag(true);
											u.SetCommand("walkanddie", pt_2);
										}
									}
						}
				}
				else {
					hide_peasants = false;
					.ClearDamageTaken();
					if (alive_or_dead_pop > 0) {
						for (i = peasants.count - 1; i > 0; i -= 1)//talk behaviour
							if (rand(5) > 0) {
								u = peasants[i].AsUnit();
								if (u.IsAlive)
									if (u.command == "moveenter")
										if (u.DoCarryNothing())
											for (j = i - 1; j >= 0; j -= 1) {
												u_talk = peasants[j].AsUnit();
												if (u_talk.IsAlive)
													if (u_talk.command == "moveenter")
														if (u_talk.DoCarryNothing())
															if (Dist(u.pos, u_talk.pos) < 120) {
																u.SetCommand("talk", u_talk);
																u_talk.SetCommand("talk", u);
															}
											}
							}
						found_idle_peasant = false;
						for (i = peasants.count - 1; i >= 0; i -= 1) {
							u = peasants[i].AsUnit();
							if (u.IsAlive)
								if (u.command == "idle") {
									pt_1 = u.pos;
									if (pt_1.x == -1)
										u.Erase();
									else if (pt_1.y == -1)
										u.Erase();
									else if (u.DoCarryNothing())
										found_idle_peasant = true;
									else {
										bld_1 = .GetEnterExit();
										if (bld_1.IsValid) {
											pt_1 = bld_1.GetEnterExit();
											if (pt_1.x == -1)
												u.Erase();
											else if (pt_1.y == -1)
												u.Erase();
											else {
												u.SetCommand("moveenter", pt_1);
												u.AddCommand(false, "dismiss");
											}
										}
										else
											u.Erase();
									}
									break;
								}
						}
						if (peasants.count < total_peasants || found_idle_peasant) {
							bld_1 = .GetEnterExit();
							if (bld_1.IsValid) {
								pt_1 = bld_1.GetEnterExit();
								if (pt_1.x != -1)
									if (pt_1.y != -1) {
										for (i = 0; i < 5; i += 1) {
											bld_2 = .GetEnterExit();
											if (bld_1 != bld_2)
												break;
										}
										if (bld_2.IsValid) {
											pt_2 = bld_2.GetEnterExit();
											if (pt_2.x != -1)
												if (pt_2.y != -1) {
													i = rand(6);
													if (!found_idle_peasant) {
														if (i == 0)
															u = Place(villager_classes[1], pt_1, plr).AsUnit();
														else if (i <= 2)
															u = Place(villager_classes[rand(2)], pt_1, plr).AsUnit();
														else
															u = Place(villager_classes[rand(c)], pt_1, plr).AsUnit();
														u.SetEntering(true);
														u.SetNoAIFlag(true);
														u.SetNoselectFlag(true);
														u.SetMinimapFlag(true);
														u.SetMessengerStatus(true);
														peasants.Add(u);
													}
													if (u.IsAlive) {
														u.SetCommand("moveenter", pt_2);
														if (i <= 2) {
															u.AddCommand(false, "disappear");
															if (i == 0)
																u.AddCommand(false, "grab_water");
															else
																u.AddCommand(false, "grab_goods");
															u.AddCommand(false, "moveenter", pt_1);
														}
														u.AddCommand(false, "dismiss");
														u.SetCmdEnable(false);
													}
												}
										}
									}
							}
						}
					}
				}

				prev_pop = alive_or_dead_pop;

				Sleep(2500);
				pop_timer -= 2500;
				hide_timer = MAX(0, hide_timer - 2500);
			}
		}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);