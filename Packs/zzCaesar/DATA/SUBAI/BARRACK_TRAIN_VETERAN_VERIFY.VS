//bool, ObjList objs, str OUT reasonText

Barrack this;
str unit_class;

this = objs[0].AsBarrack();

unit_class = cmdparam;

if (unit_class == "RGladiatorVeteran") {
	if (IsResearched(.settlement, "Gladiator Shows"))
		if (IsResearched(.player, "Veteran Offence")) {
			reasonText = rollover(this, unit_class, true);
			return true;
		}
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translate("Requires Gladiator shows and Veteran offence from Arena");
}
else {//ISlingerVeteran
	if (IsResearched(.settlement, "Slings"))
		if (IsResearched(.settlement, "Veteran's guild")) {
			reasonText = rollover(this, unit_class, true);
			return true;
		}
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translate("Requires Slings from Blacksmith and Veterans guild from Arena");
}

return false;