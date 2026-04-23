//void, Obj This

;//this empty instruction avoids problems due to starting the script with a scope

//use a scope to remove variables when the final loop is reached
{
	ItemHolder this;

	this = This.AsItemHolder();

	if (.IsValid) {
		ObjList ol;
		Unit u;
		point pt_pos;
		int i, j, k, plr, rng, dead_hero_level, grave_lifetime, units_blessed;
		bool items_given;

		pt_pos = .pos;
		plr = .player;
		rng = .range;

		dead_hero_level = .maxstamina;
		grave_lifetime = 61 + 20 * dead_hero_level;
		.SetMaxHealth(grave_lifetime + 1);
		.SetHealth(grave_lifetime + 1);

		.StartAnim(1, pt_pos);
		Sleep(.TimeToAnimFinish + rand(1001));

		while (plr == .player) {
			grave_lifetime -= 1;
			.SetHealth(grave_lifetime + 1);
			if (grave_lifetime == 120)
				.SetState(2);
			else if (grave_lifetime == 60)
				.SetState(3);
			else if (grave_lifetime == 30)
				.SetState(4);
			else if (grave_lifetime == 15)
				.SetState(5);
			else if (grave_lifetime == 0)
				break;

			k += 1;
			if (k % 4 == 0) {
				ol = Intersect(ObjsInCircle(pt_pos, rng, "Hero"), ClassPlayerObjs("Hero", plr)).GetObjList();
				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.IsAlive)
						if (u.inherentlevel < dead_hero_level * 4 / 5) {
							u.SetLevel(u.inherentlevel + 1);
							CreateFeedback("Experience", u);
						}
				}
			}
			if (k % 5 == 0)
				.SetStamina(.stamina + 1);

			if (.stamina > 0) {
				ol = Intersect(ObjsInCircle(pt_pos, rng, "Military"), ClassPlayerObjs("Military", plr)).GetObjList();
				j = ol.count;
				i = rand(j);
				units_blessed = 0;
				while (j > 0) {
					u = ol[i].AsUnit();
					if (u.IsAlive)
						if (!u.AsHero().IsValid)
							if (u.free_item_slots > 0) {
								items_given = false;
								if (!u.HasItem("Damage charm"))
									if (u.AddItem("Damage charm"))
										items_given = true;
								if (!u.HasItem("Armor charm"))
									if (u.AddItem("Armor charm"))
										items_given = true;
								if (!u.HasItem("Health charm"))
									if (u.AddItem("Health charm"))
										items_given = true;
								if (!u.HasItem("Knowledge charm"))
									if (u.AddItem("Knowledge charm"))
										items_given = true;
								if (items_given) {
									.SetStamina(.stamina - 1);
									if (.stamina <= 0)
										break;
									units_blessed += 1;
									if (units_blessed >= 5)
										break;
								}
							}
					i += 1;
					if (i >= ol.count)
						i = 0;
					j -= 1;
				}
			}

			Sleep(1000);
		}

		.StartAnim(9, pt_pos);
		Sleep(.TimeToAnimFinish);

		.Erase();
	}
}

//without this instruction, the game crashes
while (true)
	Sleep(3600000);