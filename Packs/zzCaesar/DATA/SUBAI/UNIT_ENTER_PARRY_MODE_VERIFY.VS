//bool, ObjList objs, str OUT reasonText

Unit u;
int i;

for (i = objs.count - 1; i >= 0; i -= 1) {
	u = objs[i].AsUnit();
	if (u.IsAlive)
		if (u.HasSpecial(parry))
			if (u.GetParryMode() == 0)
				return true;
}

return false;