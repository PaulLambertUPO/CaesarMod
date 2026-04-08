//bool, ObjList objs, str OUT reasonText

Obj o;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsValid)
		if (IsResearched(o.player, "Teuton Master"))
			return true;
}

reasonText = rollover(o, false) + "\n<color 255 0 0>" + Translate("Requires Teuton Master from Sanctuary of Wotan");

return false;