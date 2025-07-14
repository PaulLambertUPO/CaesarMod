//bool, ObjList objs, str OUT reasonText

Unit u;
int i;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (u.stamina >= cmdcost_stamina) {
			reasonText = rollover(u, false);
			return true;
		}
}

reasonText = rollover(u, true);

return false;