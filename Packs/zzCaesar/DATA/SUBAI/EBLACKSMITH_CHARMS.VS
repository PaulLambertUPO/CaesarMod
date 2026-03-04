//void, Obj This

Building this;

this = This.AsBuilding();

EnvWriteString(this, "researching", "yes");//no is already managed in "on_finish_research.vs"

.Progress();

{
	Settlement set;
	ObjList ol;
	Unit u;
	str charm;
	int i, count_units;

	set = .settlement;

	charm = cmdparam;

	ol = set.ObjectsAround("Military");

	for (i = ol.count - 1; i >= 0; i -= 1) {
		u = ol[i].AsUnit();
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