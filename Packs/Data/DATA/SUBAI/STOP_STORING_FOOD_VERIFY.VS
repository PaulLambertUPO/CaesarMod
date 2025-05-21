//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (.IsValid)
	if (EnvReadString(this, "researching") != "yes")
		if (EnvReadInt(.settlement, "IsStoring") == 1)
			return true;

return false;