//bool, ObjList objs, str OUT reasonText

Building this;
str production;

this = objs[0].AsBuilding();

production = EnvReadString(.settlement, "ENV_TProd");

if (production == "")
	return true;

if (production != cmdparam)
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("(A different training has already started)");

return false;