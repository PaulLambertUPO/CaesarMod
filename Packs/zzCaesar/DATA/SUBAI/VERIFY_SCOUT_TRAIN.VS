//bool, ObjList objs, str OUT reasonText

Building this;
str dest;

this = objs[0].AsBuilding();
dest = cmdparam;

if (IsResearched(.player, "Tame horses")) {
	int horses;

	horses = EnvReadInt(.settlement, "EEE_IVillageNumberHorses");

	if (horses > 0) {
		if (horses - .CmdCount("callIScout") > 0) {
			reasonText = rollover(this, ParseStr(dest, dest), true);
			return true;
		}
		reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("There are already enough queued commands to use all horses");
	}
	else
		reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translate("Requires 1 horse");
}
else
	reasonText = rollover(this, ParseStr(dest, dest), false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Tame horses");

return false;