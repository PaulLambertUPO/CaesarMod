//bool, ObjList objs, str OUT reasonText

str production;

production = EnvReadString(objs[0].AsBuilding().settlement, "ENV_TProd");

if (production == "")
	return true;

if (production != cmdparam)
	reasonText = rollover() + "\n<color 255 0 0>" + Translate("(A different training has already started)");

return false;