//bool, ObjList objs, str OUT reasonText

if (objs.count == 1) {
	Obj this;

	this = objs[0];

	if (.IsAlive)
		if (.max_items > 0)
			if (.free_item_slots > 0)
				return true;
			else
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Inventory full");
}

return false;