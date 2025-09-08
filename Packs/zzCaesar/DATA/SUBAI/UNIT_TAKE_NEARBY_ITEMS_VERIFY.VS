//bool, ObjList objs, str OUT reasonText

if (objs.count == 1) {
	Unit this;

	this = objs[0].AsUnit();

	if (.IsValid)
		if (.max_items > 0)
			if (.free_item_slots > 0) {
				ObjList item_holders;

				item_holders = ObjsInRange(this, "ItemHolder", .sight + 20).GetObjList();

				if (item_holders.count > 0) {
					ItemHolder holder;
					int i;

					for (i = 0; i < item_holders.count; i += 1) {
						holder = item_holders[i].AsItemHolder();
						if (holder.IsValid)
							if (holder.count > 0)
								return true;
					}

					reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("No items to take");
				}
				else
					reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("No item holders in sight");
			}
			else
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Inventory full");
}

return false;