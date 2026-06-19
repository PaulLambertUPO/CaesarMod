//bool, ObjList objs, str OUT reasonText
//cmdparam: "unit_class, train_type, research_2, research_1, research_building"

Barrack this;
str dest, unit_class, train_type;

this = objs[0].AsBarrack();

dest = cmdparam;
unit_class = ParseStr(dest, dest);
train_type = ParseStr(dest, dest);

if (IsResearched(.settlement, ParseStr(dest, dest))) {
	if (train_type == "discounted") {
		reasonText = rollover(this, unit_class, true);
		return true;
	}
}
else if (train_type == "base") {
	str research_1;

	research_1 = ParseStr(dest, dest);

	if (IsResearched(.settlement, research_1)) {
		reasonText = rollover(this, unit_class, true);
		return true;
	}
	else
		reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", research_1, ParseStr(dest, dest));
}

return false;