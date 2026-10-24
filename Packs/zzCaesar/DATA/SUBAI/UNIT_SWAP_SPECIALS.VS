//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

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
			if (!u.HasSpecial(spec_to)) {//this check is needed to avoid removing a special from a unit who has both (for multiple/hybrid selections)
				u.SetSpecial(spec_from, false);
				u.SetSpecial(spec_to, true);
				CreateFeedback("Parry", u);
			}
	}
}