//void, Obj This

Sleep(rand(800) + 200);

if (MapSize() >= 32000)//if map is huge, there might be too much lag
	while (1)
		Sleep(3600000);
else if (!This.AsBuilding().IsValid)
	while (1)
		Sleep(3600000);
else {
	Settlement this;
	Building bld1, bld2, bld_damaged;
	ObjList peasants;
	Unit u;
	StrArray villager_classes;
	point pos, pt1, pt2;
	int player, prev_pop, alive_or_dead_pop, total_peasants, hide_timer, pop_timer = 8000, i, j;
	bool hide_peasants = false, found_idle_peasant;

	this = This.AsBuilding().settlement;

	bld1 = .GetCentralBuilding();

	pos = bld1.pos;

	player = .player;
	prev_pop = .population;

	if (bld1.race == ImperialRome) {
		villager_classes[0] = "HVillagerAmbient";
		villager_classes[1] = "HWVillagerAmbient";
	}
	else {
		villager_classes[0] = bld1.raceStrPref + "VillagerAmbient";
		villager_classes[1] = bld1.raceStrPref + "WVillagerAmbient";
	}

	if (.IsVillage) {
		if (bld1.race == Carthage)
			villager_classes[2] = "OldManA";
		else if (bld1.race == Egypt)
			villager_classes[2] = "OldManA";
		else
			villager_classes[2] = "OldManE";
		for (i = rand(5) + 4; i > 0; i -= 1)//place up to 8 hens
			for (j = 0; j < 5; j += 1) {
				pt1.Set(pos.x + 600 - rand(1200), pos.y + 600 - rand(1200));
				if (IsPassable3x3(pt1)) {
					u = Place("Hen", pt1, 15);
					u.SetNoselectFlag(true);
					u.SetMinimapFlag(true);
					break;
				}
			}
	}

	while (1) {
		if (player != .player) {
			player = .player;
			for (i = 0; i < peasants.count; i += 1)
				peasants[i].SetPlayer(player);
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
			pop_timer = 8000;
		}

		bld_damaged = .MostDamagedBuilding;
		peasants.ClearDead();

		//if there is either the disabled flag, a damaged building or an enemy around, peasants go away, otherwise they do something (talking, working, walking...)
		if (EnvReadInt(this, "no_villagers") == 1)//used in "The siege of Numantia" and "Boudicca's rebellion" adventures
			hide_timer = 5000;
		else if (bld_damaged.IsValid) {
			bld_damaged.ClearDamageTaken();
			hide_timer = 5000;
		}
		else if (!Subtract(Intersect(ObjsInCircle(pos, 900, "Unit"), EnemyObjs(player, "Unit")), EnemyObjs(player, "Hen")).IsEmpty())
			hide_timer = 5000;

		if (hide_timer > 0) {
			if (!hide_peasants) {
				hide_peasants = true;
				for (i = 0; i < peasants.count; i += 1)
					if (peasants[i].command == "disappear")
						peasants[i].Erase();
					else if (peasants[i].pos.x == -1)
						peasants[i].Erase();
					else {
						pt1 = .FindNearEnterExit(peasants[i].pos);
						peasants[i].SetCommand("moveenter", pt1);
						peasants[i].AddCommand(false, "dismiss");
					}
			}
			for (alive_or_dead_pop = .PopulationDied; prev_pop < alive_or_dead_pop; prev_pop += 1)
				if (rand(5) < 2) {
					if (bld_damaged.IsValid)
						pt1 = bld_damaged.GetEnterExit();
					else
						pt1.Set(-1, -1);
					bld1 = bld_damaged;
					if (pt1.x == -1)
						if (pt1.y == -1) {
							bld1 = .GetEnterExit();
							if (bld1.IsValid)
								pt1 = bld1.GetEnterExit();
						}
					if (bld1.IsValid)
						if (pt1.x != -1)
							if (pt1.y != -1) {
								pt2.Set(pt1.x * 2 - bld1.pos.x + 50 - rand(100), pt1.y * 2 - bld1.pos.y + 50 - rand(100));
								u = Place(villager_classes[rand(villager_classes.size)], pt1, player);
								u.SetNoselectFlag(true);
								u.SetMinimapFlag(true);
								u.SetCommand("walkanddie", pt2);
							}
				}
		}
		else {
			hide_peasants = false;
			.ClearDamageTaken();
			if (alive_or_dead_pop > 0) {
				for (i = 0; i < peasants.count - 1; i += 1)//talk behaviour
					if (rand(5) > 0)
						if (peasants[i].IsValid)
							if (!peasants[i].IsDead())
								if (peasants[i].command == "moveenter")
									if (peasants[i].AsUnit().DoCarryNothing())
										for (j = i + 1; j < peasants.count; j += 1)
											if (peasants[j].IsValid)
												if (!peasants[j].IsDead())
													if (peasants[j].command == "moveenter")
														if (peasants[j].AsUnit().DoCarryNothing())
															if (Dist(peasants[i].pos, peasants[j].pos) < 120) {
																peasants[i].SetCommand("talk", peasants[j]);
																peasants[j].SetCommand("talk", peasants[i]);
															}
				found_idle_peasant = false;
				for (i = 0; i < peasants.count; i += 1)
					if (peasants[i].command == "idle") {
						if (peasants[i].pos.x == -1)
							peasants[i].Erase();
						else if (peasants[i].pos.y == -1)
							peasants[i].Erase();
						else {
							u = peasants[i].AsUnit();
							if (u.DoCarryNothing())
								found_idle_peasant = true;
							else {
								bld1 = .GetEnterExit();
								if (bld1.IsValid) {
									pt1 = bld1.GetEnterExit();
									if (pt1.x == -1)
										u.Erase();
									else if (pt1.y == -1)
										u.Erase();
									else {
										u.SetCommand("moveenter", pt1);
										u.AddCommand(false, "dismiss");
									}
								}
								else
									u.Erase();
							}
						}
						break;
					}
				if (peasants.count < total_peasants || found_idle_peasant) {
					bld1 = .GetEnterExit();
					if (bld1.IsValid) {
						pt1 = bld1.GetEnterExit();
						if (pt1.x != -1)
							if (pt1.y != -1) {
								for (i = 0; i < 5; i += 1) {
									bld2 = .GetEnterExit();
									if (bld1 != bld2)
										break;
								}
								if (bld2.IsValid) {
									pt2 = bld2.GetEnterExit();
									if (pt2.x != -1)
										if (pt2.y != -1) {
											i = rand(6);
											if (!found_idle_peasant) {
												if (i == 0)
													u = Place(villager_classes[1], pt1, player);
												else if (i <= 2)
													u = Place(villager_classes[rand(2)], pt1, player);
												else
													u = Place(villager_classes[rand(villager_classes.size)], pt1, player);
												u.SetEntering(true);
												u.SetMessengerStatus(true);
												u.SetNoselectFlag(true);
												u.SetMinimapFlag(true);
												peasants.Add(u);
											}
											u.SetCommand("moveenter", pt2);
											if (i <= 2) {
												u.AddCommand(false, "disappear");
												if (i == 0)
													u.AddCommand(false, "grab_water");
												else
													u.AddCommand(false, "grab_goods");
												u.AddCommand(false, "moveenter", pt1);
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
		prev_pop = alive_or_dead_pop;
		Sleep(2517);
		pop_timer -= 2517;
		hide_timer = MAX(0, hide_timer - 2517);
	}
}