//bool, ObjList objs, str OUT reasonText

ObjList builders;

builders = _GetSelection().GetCanExecCmd("build_catapult");

builders.ClearDead();

if (builders.count >= 1)
	return true;

reasonText = Translate("You need to select more units to build the machine");

return false;