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

if (unit_class == "RGladiator")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
else if (unit_class == "RGladiatorPunic")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Arena", research);
else if (unit_class == "EAnubisWarrior")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
else if (unit_class == "EHorusWarrior")
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Temple of Horus and Anubis", research);
else
	reasonText = rollover(this, unit_class, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 from Blacksmith", research);

return false;