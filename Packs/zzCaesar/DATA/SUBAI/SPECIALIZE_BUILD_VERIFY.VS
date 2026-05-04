//bool, ObjList objs, str OUT reasonText

Building this;
str dest, unit_class, specialization;

this = objs[0].AsBuilding();

dest = cmdparam;
unit_class = ParseStr(dest, dest);
specialization = ParseStr(dest, dest);

if (specialization == "spec") {
	if (EnvReadString(.settlement, unit_class) == "researched") {//do not use IsResearched here because there are no commands with unit name
		reasonText = rollover(this, unit_class, true);
		return true;
	}
}
else if (specialization == "non-spec")
	if (EnvReadString(.settlement, unit_class) != "researched") {//do not use IsResearched here because there are no commands with unit name
		reasonText = rollover(this, unit_class, true);
		return true;
	}

return false;