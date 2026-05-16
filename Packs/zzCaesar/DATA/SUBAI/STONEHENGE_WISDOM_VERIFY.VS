//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid)
	if (.command == "idle")
		if (.IsStonehengeControlable)
			if (.stamina >= GetCmdStaminaCost("wisdom"))
				return true;
			else
				reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Stonehenge is insufficiently charged");
		else
			reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Stonehenge isn't under your control");
	else
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("You must wait for the current spell to be completed");

return false;