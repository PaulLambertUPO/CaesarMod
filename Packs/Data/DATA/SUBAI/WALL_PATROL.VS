// void, Obj This

point route0, route1, tpt;
point front0, front1;
point observation_point;
Building this;
ObjList list, list1;
int player;
IntArray slots;
int num_slots;
bool mobilized = false;
bool enemies_around;
int way_point_pos;
Obj new_sentry, s1;
int count, k, i, d, d1;
str sentry_class_name;
int level, new_level;
int nWallRange = 700;

Sleep(rand(500) + 500);

if (GetConst("NoSentries") != 0)
{	// disable sentries
	while (1)
		Sleep(100000);
}

if (!This.IsValid()) {
	//pr("Ivalid wall!");
	while(1) Sleep(100000);  // fixme!!
}

this = This.AsBuilding();

num_slots = .GetNumSentrySlots();
sentry_class_name = .GetSentryClassName();

//Place("Feedback", .pos + .GetPoint(2, 0), .player);
//Place("Feedback", .pos + .GetPoint(2, 1), .player);
//Place("Feedback", .pos + .GetPoint(3, 0), .player);
//Place("Feedback", .pos + .GetPoint(3, 1), .player);

// calc the patroling route
{
	point a, b, d, d1, w;
	int s, k;
	a = .GetPoint(2, 0);
	b = .GetPoint(2, 1);
	front0 = .GetPoint(3, 0);
	front1 = .GetPoint(3, 1);
	if (a.x == -32768 || b.x == -32768 || front0.x == -32768 || front1.x == -32768) {
		//pr("Wall route point not defined!");
		while(1) Sleep(100000);  // fixme!!
	}
	w = .GetPoint(17, 0);
	way_point_pos = -1;
	if (w.x != -32768) {
		d = a - w;
		d1 = b - w;
		if (d.x*d.x + d.y*d.y < d1.x*d1.x + d1.y*d1.y) {
			a = w;
			way_point_pos = 0;
		} else {
			b = w;
			way_point_pos = 1;
		}
	}
	d = b - a;
	s = d.x*d.x + d.y*d.y;

	d1 = front0 - a;
	k = (100*(d.x*d1.x + d.y*d1.y))/s;
	route0 = .pos + a + ((b - a)*k)/100;
	front0 = front0 + .pos;

	d1 = front1 - a;
	k = (100*(d.x*d1.x + d.y*d1.y))/s;
	route1 = .pos + a + ((b - a)*k)/100;
	front1 = front1 + .pos;
	
	observation_point = (front0 + front1) / 2;
}

while (!.settlement().IsValid())
	Sleep(1000);
.settlement().AddMaxSentries(1);

level = 1;
player = .player;

while (1)
{
	if (.IsVeryBroken() || (player != .player))
	{
		list.ClearDead();
		count = list.count();
		if (count > 0) {
			for (k = 0; k < count; k += 1) {
				Sleep(rand(300) + 200);
				if (list[k].IsAlive())
					list[k].Damage(10000);
				if (player == .player)
					.settlement().DelSentry();
			}
			list.ClearDead();
		}
		for (k = 0; k < num_slots; k += 1)
			slots[k] = -1;
		player = .player;
		Sleep(2000);

	} else {

		new_level = EnvReadInt(.settlement, "SentriesLevel");
		if (new_level > level) {
			count = list.count();
			for (k = 0; k < count; k += 1) {
				if (list[k].IsAlive())
					list[k].AsUnit().SetLevel(new_level);
			}
			level = new_level;
		}

		enemies_around = false;
		if (list.count() > 0)
		if (list[0].IsAlive())
			enemies_around = EnemyInRange(.pos, nWallRange, list[0]);

		if (mobilized) {
			// a stupid way to clear the dead
			list1.Clear();
			i = 0;
			for (k = 0; k < num_slots; k += 1) {
				if (slots[k] == -1) continue;
				if (list[slots[k]].IsDead()) {
					slots[k] = -1;
					.settlement().DelSentry();
				} else {
					list1.Add(list[slots[k]]);
					slots[k] = i;
					i += 1;
				}
			}
			list.Clear();
			for (k = 0; k < i; k += 1) {
				list.Add(list1[k]);
				if (list1[k].command() == "idle")
					list1[k].SetCommand("guard", This);
			}
			count = i;
		} else {
			count = list.count();
			for (k = 0; k < count; k += 1)
				if (list[k].IsDead()) .settlement().DelSentry();
				else if (list[k].command() != "patrol")
					list[k].SetCommand("patrol", This);
			list.ClearDead();
		}
		
		if (enemies_around) {
			if (!mobilized) {
				for (k = 0; k < num_slots; k += 1)
					slots[k] = -1;
			}
			if (!mobilized && count != 0) {
				// assign the current patroling sentry (if any) to the nearest slot
				i = 0;
				tpt = route0 + (route1 - route0)/(2*num_slots) - list[0].AsUnit.pos();
				d = tpt.x*tpt.x + tpt.y*tpt.y;
				for (k = 1; k < num_slots; k += 1) {
					tpt = route0 + (route1 - route0)*(1 + 2*k)/(2*num_slots) - list[0].AsUnit.pos();
					d1 = tpt.x*tpt.x + tpt.y*tpt.y;
					if (d1 < d) {
						i = k;
						d = d1;
					}
				}
				slots[i] = 0;
				list[0].SetCommand("goto", route0 + (route1 - route0)*(1 + 2*i)/(2*num_slots));
				list[0].AddCommand(false, "goto", front0 + (front1 - front0)*(1 + 2*i)/(2*num_slots));
				list[0].AddCommand(false, "guard", This);
			} else {
				// first call back any retreating sentries
				for (k = 0; k < num_slots; k += 1) {
					if (slots[k] == -1) continue;
					s1 = list[slots[k]];
					if (s1.command() == "attack") continue;
					i = 0;
					while (s1.command(i) == "goto") i += 1;
					if (s1.command(i) != "guard") {
						s1.SetCommand("goto", route0 + (route1 - route0)*(1 + 2*k)/(2*num_slots));
						s1.AddCommand(false, "goto", front0 + (front1 - front0)*(1 + 2*k)/(2*num_slots));
						s1.AddCommand(false, "guard", This);
					}
				}
				// find some free slot (if any) and assign a new sentry there (if there is one available in the pool)
				i = -1;
				for (k = 0; k <= num_slots/2; k += 1) {
					if (slots[k] == -1) {
						i = 0;
						break;
					}
					if (slots[num_slots - k - 1] == -1) {
						k = num_slots - k - 1;
						i = 1;
						break;
					}
				}
				if (i >= 0) {
					if (.settlement().GetSentry()) {
						slots[k] = count;
						new_sentry = Place(sentry_class_name, .pos + .GetPoint(2, i), .player);
						new_sentry.AsUnit().SetLevel(level);
						list.Add(new_sentry);
						if (i == way_point_pos) {
							new_sentry.SetCommand("goto", .pos + .GetPoint(17, 0));
							new_sentry.AddCommand(false, "goto", route0 + (route1 - route0)*(1 + 2*k)/(2*num_slots));
						} else new_sentry.SetCommand("goto", route0 + (route1 - route0)*(1 + 2*k)/(2*num_slots));
						new_sentry.AddCommand(false, "goto", front0 + (front1 - front0)*(1 + 2*k)/(2*num_slots));
						new_sentry.AddCommand(false, "guard", This);
					}
				}
			}
			mobilized = true;
		} else {
			if (mobilized) {
				if (count > 1) {
					// try to find one waiting sentry
					i = -1;
					for (k = 0; k <= num_slots/2; k += 1) {
						if (slots[k] != -1) if (list[slots[k]].command() == "guard") {
							i = 0;
							break;
						}
						d = num_slots - k - 1;
						if (slots[d] != -1) if (list[slots[d]].command() == "guard") {
							k = d;
							i = 1;
							break;
						}
					}
					if (i >= 0) {
						// withdraw the sentry
						list[slots[k]].SetCommand("goto", route0 + (route1 - route0)*(1 + 2*k)/(2*num_slots));
						if (i == way_point_pos) list[slots[k]].AddCommand(false, "goto", .pos + .GetPoint(17, 0));
						list[slots[k]].AddCommand(false, "goto", .pos + .GetPoint(2, i));
						list[slots[k]].AddCommand(false, "disappear", This);
					}
				} else {
					// if there is only one sentry left, order him to patrol
					if (count > 0) {
	//					list[0].AsUnit().Stop(1000);
						list[0].SetCommand("patrol", This);
					}
					mobilized = false;
				}
			}
			if (!mobilized) {
				// if no sentry on the wall, call one (if available)
				if (count == 0) {
					if (.settlement().GetSentry()) {
						i = rand(256)/128;
						new_sentry = Place(sentry_class_name, .pos + .GetPoint(2, i), .player);
						new_sentry.AsUnit().SetLevel(level);
						list.Add(new_sentry);
						if (i == way_point_pos) {
							new_sentry.SetCommand("goto", .pos + .GetPoint(17, 0));
							new_sentry.AddCommand(false, "patrol", This);
						} else new_sentry.SetCommand("patrol", This);
					}
				}
			}
		}

		if (list.count > 0)
			RevealHiddenEnemyUnits(observation_point, 500, .player);

		if (mobilized)
			Sleep(750);
		else
			Sleep(1500);
	}
}
