//bool, ObjList objs, str OUT reasonText

Unit u;
int i;
str research;

research = cmdparam;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (IsResearched(u.player, research))
			return true;
}

reasonText = rollover(u, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);

return false;