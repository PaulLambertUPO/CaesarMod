//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid)
	if (.command == "idle")
		if (.IsStonehengeControlable())
			if (.stamina >= GetCmdStaminaCost("foraging"))
				return true;
			else
				reasonText = rollover(this, true) + "<color 255 0 0>\n" + Translate("Stonehenge is insufficiently charged");
		else
			reasonText = rollover(this, true) + "<color 255 0 0>\n" + Translate("Stonehenge isn't under your control");
	else
		reasonText = rollover(this, true) + "<color 255 0 0>\n" + Translate("You must wait for the current spell to be completed");

return false;