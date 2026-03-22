//bool, ObjList objs, str OUT reasonText

Obj o;
int i;
str research;

research = cmdparam;

for (i = objs.count - 1; i >= 0; i -= 1) {
	o = objs[i];
	if (o.IsAlive)
		if (IsResearched(o.player, research))
			return true;
}

reasonText = rollover(o, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);

return false;