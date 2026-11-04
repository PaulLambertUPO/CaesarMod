//bool, ObjList objs, str OUT reasonText

Building this;
str charm;

this = objs[0].AsBuilding();

charm = cmdparam;

if (.CmdCount(charm) < 1) {
	ObjList ol;
	Obj o;
	int i, count_units;

	ol = .settlement.ObjectsAround("Military");

	for (i = ol.count - 1; i >= 0; i -= 1) {
		o = ol[i];
		if (o.IsAlive)
			if (!.IsEnemy(o))
				if (o.free_item_slots > 0)
					if (!o.HasItem(charm))
						if (!o.IsSentry)
							if (!o.AsHero().IsValid) {
								count_units += 1;
								if (count_units >= 5) {
									reasonText = rollover(this, true);
									return true;
								}
							}
	}

	reasonText = rollover(this, false) + "\n<color 255 0 0 >" + Translate("Requires at least 5 warriors without the charm around the settlement");
}
else
	reasonText = rollover(this, true);

return false;