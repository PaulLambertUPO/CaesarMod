//bool, ObjList objs, str OUT reasonText

Barrack this;
str dest, unit_class, research;

this = objs[0].AsBarrack();

dest = cmdparam;

unit_class = ParseStr(dest, dest);
research = ParseStr(dest, dest);

if (IsResearched(.settlement, research)) {//sacred legion
	research = ParseStr(dest, dest);

	if (IsResearched(.player, research)) {//dark rituals
		reasonText = rollover(this, unit_class, true);
		return true;
	}
}

reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1", research);

return false;