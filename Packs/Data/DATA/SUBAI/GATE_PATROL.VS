//void, Obj This

Sleep(500 + rand(1001));

if (GetConst("NoSentries") == 0) {
	Gate this;

	this = This.AsGate();

	if (.IsValid) {
		Settlement set;
		point exit_1, exit_2, pt_outer_1, pt_outer_2, pt_inner_1, pt_inner_2;

		{
			exit_1 = .GetPoint(2, 0);

			if (exit_1.x != -32768) {//check if gate exit point 1 is defined
				exit_2 = .GetPoint(2, 1);

				if (exit_2.x != -32768) {//check if gate exit point 2 is defined
					IntArray dists, indxs;
					point pt;
					int i;

					for (i = 0; i < 4; i += 1) {//check if gate attack points are defined
						pt = .GetPoint(3, i);
						if (pt.x == -32768)
							break;
						pt = pt - exit_1;
						dists[i] = pt.x * pt.x + pt.y * pt.y;//use square to sort points with every gate orientation
						indxs[i] = i;
					}

					if (pt.x != -32768) {//if all attack points are defined, sort them by the shortest to highest distance from exit point 1
						int j, k, l;

						for (i = 0; i < 3; i += 1)
							for (j = i + 1; j < 4; j += 1) {
								k = indxs[i];
								l = indxs[j];
								if (dists[k] > dists[l]) {//do not sort distances but only indexes
									indxs[i] = l;
									indxs[j] = k;
								}
							}

						pt = .pos;
						exit_1 = pt + exit_1;
						pt_outer_1 = pt + .GetPoint(3, indxs[0]);
						pt_inner_1 = pt + .GetPoint(3, indxs[1]);
						pt_inner_2 = pt + .GetPoint(3, indxs[2]);
						pt_outer_2 = pt + .GetPoint(3, indxs[3]);
						exit_2 = pt + exit_2;

						set = .settlement;
					}
				}
			}
		}

		if (set.IsValid) {
			while (set.IsIndependent)
				Sleep(5000);

			{
				Unit sentry_outer_1, sentry_inner_1, sentry_inner_2, sentry_outer_2;
				str sentry_class_name;
				int plr, sentry_level;

				set.AddMaxSentries(4);

				sentry_class_name = .GetSentryClassName();
				plr = .player;

				while (1) {
					if (.IsVeryBroken || plr != .player) {
						if (sentry_outer_1.IsValid) {
							if (sentry_outer_1.IsAlive) {
								sentry_outer_1.Damage(sentry_outer_1.health);
								if (plr == .player)
									set.DelSentry();
							}
							sentry_outer_1.Clear();
						}
						if (sentry_inner_1.IsValid) {
							if (sentry_inner_1.IsAlive) {
								sentry_inner_1.Damage(sentry_inner_1.health);
								if (plr == .player)
									set.DelSentry();
							}
							sentry_inner_1.Clear();
						}
						if (sentry_inner_2.IsValid) {
							if (sentry_inner_2.IsAlive) {
								sentry_inner_2.Damage(sentry_inner_2.health);
								if (plr == .player)
									set.DelSentry();
							}
							sentry_inner_2.Clear();
						}
						if (sentry_outer_2.IsValid) {
							if (sentry_outer_2.IsAlive) {
								sentry_outer_2.Damage(sentry_outer_2.health);
								if (plr == .player)
									set.DelSentry();
							}
							sentry_outer_2.Clear();
						}
						plr = .player;
					}
					else {
						sentry_level = MAX(1, EnvReadInt(set, "SentriesLevel"));

						if (sentry_outer_1.IsValid)
							if (sentry_outer_1.IsAlive) {
								if (sentry_outer_1.inherentlevel < sentry_level)
									sentry_outer_1.SetLevel(sentry_level);
								if (sentry_outer_1.command != "guard")
									if (sentry_outer_1.command != "attack") {
										sentry_outer_1.SetCommand("goto", pt_outer_1);
										sentry_outer_1.AddCommand(false, "guard", this);
									}
							}
							else {
								set.DelSentry();
								sentry_outer_1.Clear();
							}
						else if (set.GetSentry()) {
							sentry_outer_1 = Place(sentry_class_name, exit_1, plr).AsUnit();
							sentry_outer_1.SetLevel(sentry_level);
							sentry_outer_1.SetCommand("goto", pt_outer_1);
							sentry_outer_1.AddCommand(false, "guard", this);
						}

						if (sentry_inner_1.IsValid)
							if (sentry_inner_1.IsAlive) {
								if (sentry_inner_1.inherentlevel < sentry_level)
									sentry_inner_1.SetLevel(sentry_level);
								if (sentry_inner_1.command != "guard")
									if (sentry_inner_1.command != "attack") {
										sentry_inner_1.SetCommand("goto", pt_inner_1);
										sentry_inner_1.AddCommand(false, "guard", this);
									}
							}
							else {
								set.DelSentry();
								sentry_inner_1.Clear();
							}
						else if (sentry_outer_1.IsValid) {
							sentry_outer_1.SetCommand("goto", pt_inner_1);
							sentry_outer_1.AddCommand(false, "guard", this);
							sentry_inner_1 = sentry_outer_1;
							sentry_outer_1.Clear();
						}

						if (sentry_outer_2.IsValid)
							if (sentry_outer_2.IsAlive) {
								if (sentry_outer_2.inherentlevel < sentry_level)
									sentry_outer_2.SetLevel(sentry_level);
								if (sentry_outer_2.command != "guard")
									if (sentry_outer_2.command != "attack") {
										sentry_outer_2.SetCommand("goto", pt_outer_2);
										sentry_outer_2.AddCommand(false, "guard", this);
									}
							}
							else {
								set.DelSentry();
								sentry_outer_2.Clear();
							}
						else if (set.GetSentry()) {
							sentry_outer_2 = Place(sentry_class_name, exit_2, plr).AsUnit();
							sentry_outer_2.SetLevel(sentry_level);
							sentry_outer_2.SetCommand("goto", pt_outer_2);
							sentry_outer_2.AddCommand(false, "guard", this);
						}

						if (sentry_inner_2.IsValid)
							if (sentry_inner_2.IsAlive) {
								if (sentry_inner_2.inherentlevel < sentry_level)
									sentry_inner_2.SetLevel(sentry_level);
								if (sentry_inner_2.command != "guard")
									if (sentry_inner_2.command != "attack") {
										sentry_inner_2.SetCommand("goto", pt_inner_2);
										sentry_inner_2.AddCommand(false, "guard", this);
									}
							}
							else {
								set.DelSentry();
								sentry_inner_2.Clear();
							}
						else if (sentry_outer_2.IsValid) {
							sentry_outer_2.SetCommand("goto", pt_inner_2);
							sentry_outer_2.AddCommand(false, "guard", this);
							sentry_inner_2 = sentry_outer_2;
							sentry_outer_2.Clear();
						}
					}

					Sleep(1000);
				}
			}
		}
	}
}

//without this instruction, the game crashes
while (1)
	Sleep(3600000);