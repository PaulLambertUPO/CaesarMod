//void, Obj This

Building this;

this = This.AsBuilding();

EnvWriteString(this, "researching", "yes");

.Progress();

{
	Settlement set;
	ObjList ol;
	Obj o;
	str charm;
	int i, count_units;

	set = .settlement;

	charm = cmdparam;

	ol = set.ObjectsAround("Military");

	for (i = ol.count - 1; i >= 0; i -= 1) {
		o = ol[i];
		if (o.IsAlive)
			if (!.IsEnemy(o))
				if (o.free_item_slots > 0)
					if (!o.HasItem(charm))
						if (!o.IsSentry)
							if (!o.AsHero().IsValid)
								if (o.AddItem(charm)) {
									count_units += 1;
									if (count_units >= 65)
										break;
								}
	}
}