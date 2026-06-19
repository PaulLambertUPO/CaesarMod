//bool, ObjList objs, str OUT reasonText

Barrack this;
str dest, unit_class, research;

this = objs[0].AsBarrack();

dest = cmdparam;
unit_class = ParseStr(dest, dest);
research = ParseStr(dest, dest);

if (EnvReadString(.settlement, research) == "researched") {//do not use IsResearched because there are some researches that set different values from their command name
	reasonText = rollover(this, unit_class, true);
	return true;
}

reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from %s2", research, ParseStr(dest, dest));

return false;