//bool, ObjList objs, str OUT reasonText

Obj o;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		if (IsResearched(o.player, "Teuton Master"))
			return true;
}

reasonText = rollover() + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", "Teuton Master", "Sanctuary of Wotan");

return false;