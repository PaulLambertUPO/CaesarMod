//void, Obj This

Building this;

Sleep(rand(1000) + 500);

this = This.AsBuilding();

if (.class != "TTent")//this is to manage CTent because it heirs everything from TTent, including behaviour scripts
	while (1)
	 	Sleep(3600000);
else {
	Settlement set;
	ObjList all_teutons, teutons_1, teutons_2, teutons_out, enemies;
	Unit u;
	point pos, pt1, pt2;
	rect rc;
	int i, j, sight, player, initial_army, active_army, spawn_rate, last_spawn_time, delay, exp_gain, old_exp_gain;
	bool first_time_independent;

	set = .settlement;

	set.SetLoyalty(100);//impossible to capture until the garrison is defeated

	rc = GetMapRect();

	sight = .sight;
	pos = .pos;

	initial_army = GetConst("TTentInitialArmy");
	active_army = GetConst("TTentActiveArmy");
	spawn_rate = GetConst("TTentUnitSpawnRate");

	last_spawn_time = spawn_rate * initial_army / 2;//spawn half of the army at the beginning

	first_time_independent = set.IsIndependent;

	while (1) {
		player = .player;
		exp_gain = MAX(0, GetTime() / 120000 - 5);

		//spawn neutral or produced teutons
		if (set.IsIndependent) {
			teutons_1.ClearDead();
			teutons_2.ClearDead();
			while (last_spawn_time > spawn_rate) {
				last_spawn_time -= spawn_rate;
				if (teutons_1.count >= initial_army)
					if (teutons_2.count >= initial_army)
						break;
				if (teutons_1.count < initial_army) {
					u = Place("TTeutonRider", pos, player);
					u.SetFeeding(false);
					set.ForceAddUnit(u);
					u.SetExperience(old_exp_gain);
					teutons_1.Add(u);
					all_teutons.Add(u);
				}
				if (teutons_2.count < initial_army) {
					u = Place("TTeutonArcher", pos, player);
					u.SetFeeding(false);
					set.ForceAddUnit(u);
					u.SetExperience(old_exp_gain);
					teutons_2.Add(u);
					all_teutons.Add(u);
				}
			}
			last_spawn_time += 1000;
		}
		else if (delay >= spawn_rate) {
			if (set.food >= 400) {
				str class_prod;
				class_prod = EnvReadString(set, "ENV_TProd");
				if (class_prod != "") {
					set.SetFood(set.food - 400);
					u = Place(class_prod, pos, player);
					u.SetFeeding(false);
					set.ForceAddUnit(u);
					u.SetExperience(old_exp_gain);
					all_teutons.Add(u);
				}
			}
			delay = 0;
		}
		else
			delay += 1000;

		//set feeding of commanded teutons
		all_teutons.ClearDead();
		for (i = all_teutons.count - 1; i >= 0; i -= 1) {
			u = all_teutons[i].AsUnit();
			if (u.IsValid)
				if (u.GetCommanded()) {
					u.SetFeeding(true);
					all_teutons.Remove(u);
				}
		}
		teutons_out.ClearDead();
		for (i = teutons_out.count - 1; i >= 0; i -= 1) {
			u = teutons_out[i].AsUnit();
			if (u.IsValid)
				if (u.GetCommanded()) {
					u.SetFeeding(true);
					teutons_out.Remove(u);
				}
		}

		//increase experience
		if (exp_gain > 0)
			if (exp_gain > old_exp_gain) {
				for (i = all_teutons.count - 1; i >= 0; i -= 1) {
					u = all_teutons[i].AsUnit();
					if (u.IsValid)
						u.SetExperience(u.experience + exp_gain - old_exp_gain);
				}
				old_exp_gain = exp_gain;
			}

		teutons_out.ClearDead();
		enemies = Intersect(
			VisibleObjsInSight(this, "Unit"),
			Subtract(
				Union(EnemyObjs(player, "Military"), EnemyObjs(player, "BaseMage")),
				EnemyObjs(player, "Sentry")
			)
		).GetObjList();
		enemies.ClearDead();
		if (enemies.count <= 0) {
			//no threat around, command all teutons that are out to come back in
			teutons_out.SetCommand("enter_tent", this);
			teutons_out.Clear();
		}
		else {
			//do not allow teutons to wander too far
			for (i = 0; i < teutons_out.count; i += 1) {
				u = teutons_out[i].AsUnit();
				if (.DistTo(u) > sight) {
					pt1 = u.pos - pos;
					pt1.SetLen(sight / 2);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.SetCommand("move", pt2);
					for (j = 0; j < 4; j += 1) {
						pt1.Rot(90);
						pt2 = pt1 + pos;
						pt2.IntoRect(rc);
						u.AddCommand(false, "patrol", pt2);
					}
				}
			}

			//get out more teutons if needed
			while (teutons_out.count < active_army && set.UnitsCount() > 0) {
				u = set.Units()[0];
				teutons_out.Add(u);
				pt1.Set(0, sight / 2);
				pt1.Rot(rand(360));
				pt2 = pt1 + pos;
				pt2.IntoRect(rc);
				u.SetCommand("advance", pt2);
				for (j = 0; j < 4; j += 1) {
					pt1.Rot(90);
					pt2 = pt1 + pos;
					pt2.IntoRect(rc);
					u.AddCommand(false, "patrol", pt2);
				}
			}

			//handle the capturing
			all_teutons.ClearDead();
			if (all_teutons.count <= 0) {
				enemies.ClearDead();
				i = enemies.count;
				if (i > 0)
					if (Intersect(VisibleObjsInSight(this, "Unit"), FriendlyObjs(player, "Military")).IsEmpty()) {//exclude hidden allies (just like with capturable buildings)
						j = enemies[rand(i)].player;
						.SetPlayer(j);
						if (first_time_independent)//spawn some teutons for the new player (only once)
							if (!set.IsIndependent) {//avoid giving units/resources to possible neutral units coming from other outposts
								int t;
								t = GetConst("TTentCapturedArmy");
								for (i = 0; i < t; i += 1) {
									u = Place("TTeutonRider", pos, j);
									set.ForceAddUnit(u);
									u.SetExperience(old_exp_gain);
									u.SetFeeding(false);
									all_teutons.Add(u);
									u = Place("TTeutonArcher", pos, j);
									set.ForceAddUnit(u);
									u.SetExperience(old_exp_gain);
									u.SetFeeding(false);
									all_teutons.Add(u);
								}
								first_time_independent = false;
							}
					}
			}
		}
		Sleep(1000);
	}
}