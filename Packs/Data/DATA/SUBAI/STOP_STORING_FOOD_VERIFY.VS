//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (EnvReadInt(.settlement, "IsStoring") == 1) {
	reasonText = rollover(this, false);
	return true;
}

return false;