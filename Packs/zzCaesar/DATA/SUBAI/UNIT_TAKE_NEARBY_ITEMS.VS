//void, Obj This

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.free_item_slots > 0)
			if (!.InHolder) {
				ObjList item_holders;
				ItemHolder holder;
				Obj o;
				int i, d, min_dist = 10000000;

				item_holders = ObjsInRange(this, "ItemHolder", .sight + 20).GetObjList();

				for (i = item_holders.count - 1; i >= 0; i -= 1) {
					o = item_holders[i];
					if (o.AsItemHolder().count > 0) {
						d = .DistTo(o);
						if (d < min_dist) {
							holder = o;
							min_dist = d;
						}
					}
				}

				if (holder.IsValid)
					.AddCommand(true, "getitems", holder);
			}

Sleep(15);//prevent possible loops with other commands