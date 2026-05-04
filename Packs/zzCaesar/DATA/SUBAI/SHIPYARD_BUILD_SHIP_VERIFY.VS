//bool, ObjList objs, str OUT reasonText

Building this;
str ship_class;
int race;

this = objs[0].AsBuilding();

ship_class = cmdparam;
race = GetPlayerRace(.player);

if (race == RepublicanRome) {
	if (ship_class != "ShipRome")
		return false;
}
else if (race == Egypt) {
	if (ship_class != "ShipEgypt")
		return false;
}
else if (ship_class != "ShipL")
	return false;

reasonText = rollover(this, ship_class, true);

return true;