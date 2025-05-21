//bool, ObjList objs, str OUT reasonText
int i;
Unit u;
bool bHasParryModeSpecial;

bHasParryModeSpecial = false;
for(i = 0; i < objs.count(); i += 1) {
	u = objs[i].AsUnit;
	if (u.IsValid)
		if (u.HasSpecial(parry))
			bHasParryModeSpecial = true;
}

if (bHasParryModeSpecial)
{
	for(i = 0; i < objs.count(); i += 1) {
		u = objs[i].AsUnit;
		if (u.IsValid)
			if (u.GetParryMode() == 0)
				return true;
	}
	reasonText = Translate("Warriors are in parry mode");
	return false;
}
return false;
