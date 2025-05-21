//bool, ObjList objs, str OUT reasonText

if (objs.count > 0)
	if (IsResearched(objs[0].player, "Teuton Master")) {
		int i;
		for (i = 0; i < objs.count; i += 1)
			if (!objs[i].IsHeirOf("TTeutonWolf"))
				return false;
		return true;
	}
	else
		reasonText = rollover(objs[0], true) + "\n<color 255 0 0>" + Translate(cmdparam);

return false;