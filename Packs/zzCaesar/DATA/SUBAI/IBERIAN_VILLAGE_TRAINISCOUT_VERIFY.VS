//bool, ObjList objs, str OUT reasonText

Building this;

this = objs[0].AsBuilding();

if (IsResearched(.player, "Tame horses")) {
	int horses;

	horses = EnvReadInt(.settlement, "EEE_IVillageNumberHorses");

	if (horses > 0) {
		if (horses - .CmdCount("trainIScout") > 0) {
			reasonText = rollover(this, cmdparam, true);
			return true;
		}
		reasonText = rollover(this, cmdparam, false) + "\n<color 255 0 0>" + Translate("There are already enough queued commands to use all horses");
	}
	else
		reasonText = rollover(this, cmdparam, false) + "\n<color 255 0 0>" + Translate("Requires 1 horse");
}
else
	reasonText = rollover(this, cmdparam, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", "Tame horses");

return false;