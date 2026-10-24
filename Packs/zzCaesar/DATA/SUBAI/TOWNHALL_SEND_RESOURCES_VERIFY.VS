//bool, ObjList objs, str OUT reasonText

Obj this;

this = objs[0];

if (AllyStrongholds(.player) - Strongholds(.player) > 0)
	if (GetTime() >= EnvReadInt(.AsBuilding().settlement, "SendResourcesCooldown"))
		return true;
	else
		reasonText = rollover() + "\n<color 255 0 0>" + Translate("At least 4 minutes must pass between each sending");
else
	reasonText = rollover() + "\n<color 255 0 0>" + Translate("There are no allied strongholds");

return false;