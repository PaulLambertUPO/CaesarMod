//bool, ObjList objs, str OUT reasonText

Unit u;
int i;

for (i = 0; i < objs.count; i += 1) {
	u = objs[i].AsUnit();
	if (u.IsValid)
		if (!u.IsSentry)
			if (u.HasSpecial(parry))
				if (u.GetParryMode() == 0)
					return true;
}

return false;