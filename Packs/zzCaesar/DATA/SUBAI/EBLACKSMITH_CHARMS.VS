//void, Obj This

Building this;

this = This.AsBuilding();

if (.IsValid) {
	Settlement set;

	set = .settlement;

	if (set.IsValid) {
		ObjList ol;
		Unit u;
		str charm;
		int i, count_units;

		EnvWriteString(this, "researching", "yes");//no is already managed in "on_finish_research.vs"

		.Progress();

		charm = cmdparam;

		ol = set.ObjectsAround("Military");
		for (i = 0; i < ol.count; i += 1) {
			u = ol[i].AsUnit();
			if (u.IsValid)
				if (u.IsAlive)
					if (!.IsEnemy(u))
						if (u.free_item_slots > 0)
							if (!u.HasItem(charm))
								if (!u.IsSentry)
									if (!u.IsHeirOf("Hero"))
										if (u.AddItem(charm)) {
											count_units += 1;
											if (count_units >= 65)
												break;
										}
		}
	}
}