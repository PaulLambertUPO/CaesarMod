//void, Obj This

Sleep(1000 + rand(1001));

if (GetConst("NoSentries") == 0) {
	Building this;

	this = This.AsBuilding();

	if (.IsValid) {
		Settlement set;
		point pt, pt_pos, exit_1, exit_2, front_1, front_2, route_1, route_2, waypoint;
		int i, way_point_pos;

		{
			exit_1 = .GetPoint(2, 0);

			if (exit_1.x != -32768) {//check if wall exit point 1 is defined
				exit_2 = .GetPoint(2, 1);

				if (exit_2.x != -32768) {//check if wall exit point 2 is defined
					front_1 = .GetPoint(3, 0);

					if (front_1.x != -32768) {//check if wall attack point 1 is defined
						front_2 = .GetPoint(3, 1);

						if (front_2.x != -32768) {//check if wall attack point 2 is defined
							point e1, e2, exit_dist_1, exit_dist_2;//e1 and e2 are used to prevent miscalculations due to the waypoint override below

							e1 = exit_1;
							e2 = exit_2;

							waypoint = .GetPoint(17, 0);

							if (waypoint.x != -32768) {
								exit_dist_1 = exit_1 - waypoint;
								exit_dist_2 = exit_2 - waypoint;
								if (exit_dist_1.x * exit_dist_1.x + exit_dist_1.y * exit_dist_1.y < exit_dist_2.x * exit_dist_2.x + exit_dist_2.y * exit_dist_2.y) {
									exit_1 = waypoint;
									way_point_pos = 0;
								}
								else {
									exit_2 = waypoint;
									way_point_pos = 1;
								}
							}
							else
								way_point_pos = -1;

							pt_pos = .pos;
							waypoint = waypoint + pt_pos;

							pt = pt_pos + exit_1;
							exit_dist_1 = exit_2 - exit_1;
							i = exit_dist_1.x * exit_dist_1.x + exit_dist_1.y * exit_dist_1.y;

							exit_dist_2 = front_1 - exit_1;
							route_1 = pt + exit_dist_1 * (exit_dist_1.x * exit_dist_2.x + exit_dist_1.y * exit_dist_2.y) * 100 / i / 100;
							front_1 = front_1 + pt_pos;

							exit_dist_2 = front_2 - exit_1;
							route_2 = pt + exit_dist_1 * (exit_dist_1.x * exit_dist_2.x + exit_dist_1.y * exit_dist_2.y) * 100 / i / 100 - route_1;
							front_2 = front_2 + pt_pos - front_1;

							exit_1 = e1 + pt_pos;
							exit_2 = e2 + pt_pos;

							set = .settlement;
						}
					}
				}
			}
		}

		if (set.IsValid) {
			while (set.IsIndependent)
				Sleep(5000);

			{
				ObjList sentries, ol;
				Obj sentry;
				IntArray slots;
				point pt_route_diff;
				str sentry_class_name;
				int j, k, c, plr, num_slots, num_slots_half, num_slots_double, sentry_level;
				bool enemies_around, mobilized = false;

				set.AddMaxSentries(1);

				sentry_class_name = .GetSentryClassName();
				num_slots = .GetNumSentrySlots();
				num_slots_half = num_slots / 2;
				num_slots_double = num_slots * 2;
				pt_route_diff = route_1 + route_2 / num_slots_double;
				plr = .player;

				while (true) {
					if (.IsBroken || plr != .player) {
						for (i = sentries.count - 1; i >= 0; i -= 1) {
							sentry = sentries[i];
							if (sentry.IsAlive) {
								sentry.Damage(sentry.health);
								if (plr == .player)
									set.DelSentry();
							}
							sentries.Remove(sentry);
						}
						for (i = 0; i < num_slots; i += 1)
							slots[i] = -1;
						plr = .player;
					}
					else {
						if (mobilized) {//specific way to clear the dead
							ol.Clear();
							i = 0;
							for (j = 0; j < num_slots; j += 1) {
								k = slots[j];
								if (k != -1) {
									sentry = sentries[k];
									if (sentry.IsDead) {
										slots[j] = -1;
										set.DelSentry();
									}
									else {
										ol.Add(sentry);
										slots[j] = i;
										i += 1;
									}
								}
							}
							sentries.Clear();
							for (j = 0; j < i; j += 1) {
								sentry = ol[j];
								sentries.Add(sentry);
								if (sentry.command == "idle")
									sentry.SetCommand("guard", this);
							}
						}
						else
							for (i = sentries.count - 1; i >= 0; i -= 1) {
								sentry = sentries[i];
								if (sentry.IsDead) {
									set.DelSentry();
									sentries.Remove(sentry);
								}
								else if (sentry.command != "attack")
									if (sentry.command != "patrol")
										sentry.SetCommand("patrol", this);
							}
						c = sentries.count;

						enemies_around = false;
						sentry_level = MAX(1, EnvReadInt(set, "SentriesLevel"));
						for (i = 0; i < c; i += 1) {
							sentry = sentries[i];
							if (sentry.IsAlive) {
								if (sentry.AsUnit().inherentlevel < sentry_level)
									sentry.AsUnit().SetLevel(sentry_level);
								if (!enemies_around)
									if (EnemyInRange(pt_pos, 700, sentry))
										enemies_around = true;
							}
						}

						if (enemies_around) {
							if (!mobilized)
								for (i = 0; i < num_slots; i += 1)
									slots[i] = -1;

							if (!mobilized && c > 0) {//assign the current patroling sentry (if any) to the nearest slot
								i = 0;
								sentry = sentries[0];
								pt = pt_route_diff - sentry.pos;
								j = pt.x * pt.x + pt.y * pt.y;
								for (k = 1; k < num_slots; k += 1) {
									pt = route_1 + route_2 * (1 + 2 * k) / num_slots_double - sentry.pos;
									c = pt.x * pt.x + pt.y * pt.y;
									if (c < j) {
										i = k;
										j = c;
									}
								}
								slots[i] = 0;
								i = 1 + 2 * i;
								sentry.SetCommand("goto", route_1 + route_2 * i / num_slots_double);
								sentry.AddCommand(false, "goto", front_1 + front_2 * i / num_slots_double);
								sentry.AddCommand(false, "guard", this);
							}
							else {//call back retreating sentries, then find a free slot (if any) and assign a new sentry there (if available)
								for (i = 0; i < num_slots; i += 1) {
									j = slots[i];
									if (j != -1) {
										sentry = sentries[j];
										if (sentry.command != "attack") {
											j = 0;
											while (sentry.command(j) == "goto")
												j += 1;
											if (sentry.command(j) != "guard") {
												j = 1 + 2 * i;
												sentry.SetCommand("goto", route_1 + route_2 * j / num_slots_double);
												sentry.AddCommand(false, "goto", front_1 + front_2 * j / num_slots_double);
												sentry.AddCommand(false, "guard", this);
											}
										}
									}
								}
								i = -1;
								for (j = 0; j <= num_slots_half; j += 1) {
									if (slots[j] == -1) {
										i = 0;
										pt = exit_1;
										break;
									}
									k = num_slots - j - 1;
									if (slots[k] == -1) {
										j = k;
										i = 1;
										pt = exit_2;
										break;
									}
								}
								if (i >= 0)
									if (set.GetSentry()) {
										slots[j] = c;
										sentry = Place(sentry_class_name, pt, plr);
										sentry.AsUnit().SetLevel(sentry_level);
										sentries.Add(sentry);
										j = 1 + 2 * j;
										if (i == way_point_pos) {
											sentry.SetCommand("goto", waypoint);
											sentry.AddCommand(false, "goto", route_1 + route_2 * j / num_slots_double);
										}
										else
											sentry.SetCommand("goto", route_1 + route_2 * j / num_slots_double);
										sentry.AddCommand(false, "goto", front_1 + front_2 * j / num_slots_double);
										sentry.AddCommand(false, "guard", this);
									}
							}

							mobilized = true;
						}
						else if (mobilized) {
							if (c > 1) {//withdraw a waiting sentry (if present)
								i = -1;
								for (j = 0; j <= num_slots_half; j += 1) {
									k = slots[j];
									if (k != -1)
										if (sentries[k].command == "guard") {
											i = 0;
											pt = exit_1;
											break;
										}
									k = num_slots - j - 1;
									c = slots[k];
									if (c != -1)
										if (sentries[c].command == "guard") {
											j = k;
											i = 1;
											pt = exit_2;
											break;
										}
								}
								if (i >= 0) {
									sentry = sentries[slots[j]];
									sentry.SetCommand("goto", route_1 + route_2 * (1 + 2 * j) / num_slots_double);
									if (i == way_point_pos)
										sentry.AddCommand(false, "goto", waypoint);
									sentry.AddCommand(false, "goto", pt);
									sentry.AddCommand(false, "disappear", this);
								}
							}
							else {//order the only sentry to patrol (if present)
								if (c > 0)
									sentries[0].SetCommand("patrol", this);
								else if (set.GetSentry()) {
									i = rand(2);
									if (i == 0)
										pt = exit_1;
									else
										pt = exit_2;
									sentry = Place(sentry_class_name, pt, plr);
									sentry.AsUnit().SetLevel(sentry_level);
									sentries.Add(sentry);
									if (i == way_point_pos) {
										sentry.SetCommand("goto", waypoint);
										sentry.AddCommand(false, "patrol", this);
									}
									else
										sentry.SetCommand("patrol", this);
								}
								mobilized = false;
							}
						}
						else if (c <= 0)//if no sentry is on the wall, call one (if available)
							if (set.GetSentry()) {
								i = rand(2);
								if (i == 0)
									pt = exit_1;
								else
									pt = exit_2;
								sentry = Place(sentry_class_name, pt, plr);
								sentry.AsUnit().SetLevel(sentry_level);
								sentries.Add(sentry);
								if (i == way_point_pos) {
									sentry.SetCommand("goto", waypoint);
									sentry.AddCommand(false, "patrol", this);
								}
								else
									sentry.SetCommand("patrol", this);
							}
					}

					Sleep(1000);
				}
			}
		}
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);