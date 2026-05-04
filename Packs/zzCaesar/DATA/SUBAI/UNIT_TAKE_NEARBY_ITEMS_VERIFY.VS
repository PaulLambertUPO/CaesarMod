//bool, ObjList objs, str OUT reasonText

if (objs.count == 1) {
	Obj this;

	this = objs[0];

	if (.IsAlive)
		if (.max_items > 0)
			if (.free_item_slots > 0) {
				if (GetTime() > EnvReadInt(.player, "TakeNearbyItemsCooldown"))//the cooldown reduces the lag caused by holding down the hotkey
					return true;

				reasonText = rollover();
			}
			else
				reasonText = rollover() + "\n<color 255 0 0>" + Translate("Inventory full");
}

return false;