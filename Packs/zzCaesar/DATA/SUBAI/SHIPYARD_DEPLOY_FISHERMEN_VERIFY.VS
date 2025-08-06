//bool, ObjList objs, str OUT reasonText

Building this;
int fishermen;

this = objs[0].AsBuilding();

reasonText = rollover(this, false);

fishermen = EnvReadInt(.settlement, "Fishermen");

if (fishermen > 0) {
	if (fishermen - .CmdCount("deployFishermen") * 5 > 0)
		return true;
	else
		reasonText = reasonText + "\n<color 255 0 0>" + Translate("There are already enough queued commands to deploy all fishermen");
}
else
	reasonText = reasonText + "\n<color 255 0 0>" + Translate("There are no fishermen in the shipyard");

return false;