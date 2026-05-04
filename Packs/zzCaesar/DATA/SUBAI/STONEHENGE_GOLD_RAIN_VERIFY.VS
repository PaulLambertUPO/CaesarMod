//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid)
	if (.command == "idle")
		if (.IsStonehengeControlable)
			if (.stamina >= GetCmdStaminaCost("gold_rain"))
				return true;
			else
				reasonText = rollover() + "\n<color 255 0 0>" + Translate("Stonehenge is insufficiently charged");
		else
			reasonText = rollover() + "\n<color 255 0 0>" + Translate("Stonehenge isn't under your control");
	else
		reasonText = rollover() + "\n<color 255 0 0>" + Translate("You must wait for the current spell to be completed");

return false;