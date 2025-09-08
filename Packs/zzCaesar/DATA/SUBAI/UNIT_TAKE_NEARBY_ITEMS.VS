//void, Obj me

Unit this;

this = me.AsUnit();

if (.IsValid)
	if (.free_item_slots > 0) {
		ObjList item_holders;
		ItemHolder h, holder;
		int i, d, min_dist = 1000000;

		item_holders = ObjsInRange(this, "ItemHolder", .sight + 20).GetObjList();

		for (i = 0; i < item_holders.count; i += 1) {
			h = item_holders[i].AsItemHolder();
			if (h.IsValid)
				if (h.count > 0) {
					d = .DistTo(h);
					if (d < min_dist) {
						holder = h;
						min_dist = d;
					} 
				}
		}

		if (holder.IsValid)
			.AddCommand(true, "getitems", holder);
	}