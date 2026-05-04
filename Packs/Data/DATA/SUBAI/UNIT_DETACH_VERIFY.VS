//bool, ObjList objs, str OUT reasonText

Unit u;
int i, c, f;

c = objs.count;

for (i = 0; i < c; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsAlive) {
		if (u.hero.IsValid)
			return true;
		if (u.HasFreedom)
			f += 1;
	}
}

if (f != c)
	reasonText = rollover() + "\n<color 255 0 0>" + Translate("Not attached to a hero");

return false;