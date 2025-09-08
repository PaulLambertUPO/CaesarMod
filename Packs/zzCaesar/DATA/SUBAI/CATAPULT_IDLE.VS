//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt) {
			if (.settlement.UnitsCount <= 0) {
				if (.race == Britain || .race == Germany) {
					Unit ram;
					str ram_class;

					if (.race == Britain)
						ram_class = "BCatapultUnit";
					else
						ram_class = "TCatapultUnit";

					ram = Place(ram_class, .pos, .player);
					ram.SetHealth(.health);
					ram.Face(ram.pos + Point(-3, -2));

					SwapSelectedObj(this, ram);

					.Erase();
				}
				else
					.Damage(.health);
			}
			Sleep(500);
		}
		else {
			Settlement set;
			int original_sight, build_speed, decay_speed, empty_time_to_decay, health_left, builders, empty_time, build_heal_perc, decay_damage_perc;

			set = .settlement;

			original_sight = .sight;

			.SetSight(GetConst("CatapultBuildSight"));

			build_speed = GetConst("CatapultBuildSpeed");
			decay_speed = GetConst("CatapultDecaySpeed");
			empty_time_to_decay = GetConst("CatapultBuildOnEmptyStartDamageTime");

			health_left = .maxhealth - .health;

			.StartDelayedAnim(1, .pos, -1);

			while (.IsAlive) {
				if (.IsBuilt)
					break;

				builders = set.UnitsCount;

				if (builders >= 1) {
					empty_time = 0;
					build_heal_perc = .maxhealth * build_speed * builders / 2000;

					if (health_left > build_heal_perc) {
						.Heal(build_heal_perc);
						health_left -= build_heal_perc;
						.SetBuildFrame(health_left);
					}
					else {
						.Heal(health_left);
						.SetBuilt();
					}
				}
				else {
					.SetBuildFrame(health_left);
					empty_time += 500;
					if (empty_time > empty_time_to_decay) {
						decay_damage_perc = .maxhealth * decay_speed * 500 / 100000;
						.Damage(decay_damage_perc);
						health_left = MIN(.maxhealth, health_left + decay_damage_perc);
					}
				}

				Sleep(500);
			}

			if (.IsAlive) {
				.SetSight(original_sight);

				if (.race == Britain)
					.SetCommand("disband");
				else if (.race == Germany)
					.SetCommand("disband");
				else {
					ExploreCircle(.player, .pos, .sight);
					.AddCommand(true, "autofire");
				}
			}
		}