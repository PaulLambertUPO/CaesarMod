//bool, ObjList objs, str OUT reasonText

Obj this;

this = objs[0];

if (.command == "idle")
	if (.AsBuilding().IsStonehengeControlable)
		if (.stamina >= cmdcost_stamina)
			return true;
		else
			reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Stonehenge is insufficiently charged");
	else
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Stonehenge isn't under your control");
else
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("You must wait for the current spell to be completed");

return false;