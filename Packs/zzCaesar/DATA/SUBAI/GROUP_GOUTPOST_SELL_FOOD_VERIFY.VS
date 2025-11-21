//bool, ObjList objs, str OUT reasonText

Building this;
Settlement set;

this = objs[0].AsBuilding();

set = .settlement;

if (EnvReadString(set, "GOutpostSellFood") != "yes")
	if (EnvReadString(set, "GOutpostSellGold") != "yes")
		return true;
	else
		reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("(Another exchange is under way)");

return false;