//void, Obj This

Sleep(750 + rand(751));

{
	Building this;
	Settlement set;
	Hero h;
	Item item_treasure;
	int item_spawn_timer;
	bool spawn_item = true;

	this = This.AsBuilding();

	set = .settlement;

	EnvWriteInt(this, "minlevel", .minlevel);

	while (true) {
		if (spawn_item) {
			if (item_spawn_timer > 0)
				item_spawn_timer -= 1;
			if (item_spawn_timer <= 0) {
				str item_id, item_types;
				int i;

				item_types = .itemtypes;
				while (item_types != "") {
					item_id = ParseStr(item_types, item_types);
					i += 1;
				}
				item_types = .itemtypes;
				i = rand(i);
				while (i > 0) {
					item_id = ParseStr(item_types, item_types);
					i -= 1;
				}

				if (.AddItem(item_id)) {
					item_treasure = .FindItem(item_id);
					spawn_item = false;
				}
			}
		}

		if (set.UnitsCount > 0) {
			h = set.Units[0].AsHero();

			if (h.IsValid)
				if (h.IsAlive) {
					h.Deselect();
					Sleep(10000);//this time must be lesser than the one in "hero_sleep.vs"
					if (h.IsAlive)
						if (h.GetHolderSett() == set) {
							int i;

							i = h.health - h.maxhealth / 5;
							if (i > 0)
								h.Damage(i);

							if (h.free_item_slots > 0) {
								i = EnvReadInt(this, "minlevel");
								if (h.inherentlevel >= i)
									if (.GiveItem(item_treasure, h)) {
										EnvWriteInt(this, "minlevel", i + .levelperitem);
										spawn_item = true;
										item_spawn_timer = 600;
									}
							}

							h.SetCommand("move", .GetExitPoint(h, .pos) + Point(10, 80));
						}
				}
		}

		Sleep(1000);
	}
}