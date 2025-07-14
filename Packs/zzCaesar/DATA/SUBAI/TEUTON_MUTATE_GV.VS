//bool, ObjList objs, str OUT reasonText

Unit u;
int i;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (IsResearched(u.player, "Teuton Master"))
			return true;
}

reasonText = rollover(u, false) + "\n<color 255 0 0>" + Translate("Requires Teuton Master from Sanctuary of Wotan");

return false;