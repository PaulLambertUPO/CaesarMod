//void, Obj This

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt) {
			if (.settlement.UnitsCount <= 0) {
				int r;

				r = .race;

				if (r == Britain || r == Germany) {
					Unit ram;
					str ram_class;

					if (r == Britain)
						ram_class = "BCatapultUnit";
					else
						ram_class = "TCatapultUnit";

					ram = Place(ram_class, .pos, .player).AsUnit();
					ram.SetHealth(.health);
					ram.Face(ram.pos + Point(-3, -2));
					ram.SetNoAIFlag(true);

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
			int i, original_sight, health_to_build, empty_time;

			set = .settlement;

			original_sight = .sight;

			.SetSight(GetConst("CatapultBuildSight"));

			health_to_build = .maxhealth - .health;

			.StartDelayedAnim(1, .pos, -1);

			while (.IsAlive) {
				if (.IsBuilt)
					break;

				i = set.UnitsCount;

				if (i >= 1) {
					empty_time = 0;
					i = .maxhealth * 15 * i / 2000;

					if (health_to_build > i) {
						.Heal(i);
						health_to_build -= i;
						.SetBuildFrame(health_to_build);
					}
					else {
						.Heal(health_to_build);
						.SetBuilt();
					}
				}
				else {
					.SetBuildFrame(health_to_build);
					empty_time += 500;
					if (empty_time > 14000) {
						i = MAX(1, .maxhealth / 20);
						.Damage(i);
						health_to_build = MIN(.maxhealth, health_to_build + i);
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