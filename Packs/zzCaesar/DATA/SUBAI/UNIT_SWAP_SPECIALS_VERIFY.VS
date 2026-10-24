//bool, ObjList objs, str OUT reasonText

Unit u;
int i, spec_from, spec_to;

{
	str specs;

	specs = cmdparam;

	spec_from = Str2Int(ParseStr(specs, specs));
	spec_to = Str2Int(ParseStr(specs, specs));
}

for (i = objs.count - 1; i >= 0; i -= 1) {
	u = objs[i].AsUnit();
	if (u.IsAlive) {
		if (u.HasSpecial(spec_from))
			if (!u.HasSpecial(spec_to))
				return true;
	}
}

return false;