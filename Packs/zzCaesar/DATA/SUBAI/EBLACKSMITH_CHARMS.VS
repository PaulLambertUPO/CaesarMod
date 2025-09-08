//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	Settlement set;

	set = .settlement;

	if (set.IsValid) {
		ObjList ol;
		Unit u;
		int i, count_units;

		EnvWriteString(this, "researching", "yes");

		.Progress();

		EnvWriteString(this, "researching", "no");

		ol = set.ObjectsAround("Military");
		for (i = 0; i < ol.count && count_units < 65; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				if (u.IsAlive)
					if (!.IsEnemy(u))
						if (u.free_item_slots > 0)
							if (!u.HasItem(cmdparam))
								if (!u.IsSentry)
									if (!u.IsHeirOf("Hero")) {
										u.AddItem(cmdparam);
										count_units += 1;
									}
		}
	}
}