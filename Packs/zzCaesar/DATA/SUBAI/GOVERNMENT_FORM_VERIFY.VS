//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (IsResearched(.settlement, "Olympic Games"))
	if (EnvReadString(this, "researching") != "yes") {
		str gov_form;
		int plr;

		gov_form = cmdparam;
		plr = .player;

		if (EnvReadString(plr, gov_form + "_researching") != "yes")
			if (EnvReadString(plr, "GovernmentForm") != gov_form) {
				reasonText = rollover(this, true);
				return true;
			}
			else
				reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already available");
		else
			reasonText = rollover(this, false) + "\n<color 0 255 0>" + Translate("Already researching");
	}
	else
		reasonText = rollover(this, true);
else
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Olympic Games");

return false;