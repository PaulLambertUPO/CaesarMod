//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();
set = .settlement;

if (EnvReadInt(set, "IsStoring") != 1)
	if (IsResearched(set, "Trade Routes")) {
		reasonText = rollover(this, true);
		return true;
	}
	else
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Trade Routes");

return false;