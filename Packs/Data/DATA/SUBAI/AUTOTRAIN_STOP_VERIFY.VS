//bool, ObjList objs, str OUT reasonText

Building this;
this = objs[0].AsBuilding();

reasonText = "";

if(.IsValid)
{
	if( EnvReadString(.settlement, "autotrain") != "on") {
		return false;
	}
	return true;
} 

return false;
