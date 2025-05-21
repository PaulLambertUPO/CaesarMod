//bool, ObjList objs, str OUT reasonText
//cmdparam: "research, research_building"

Unit this;
str dest, research;

this = objs[0].AsUnit();
dest = cmdparam;

research = ParseStr(dest, dest);

if (!IsResearched(.player, research)) {
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", research, ParseStr(dest, dest));
	return false;
}

return true;