//void, Obj This

Settlement this;
ObjList ol;

this = This.AsBuilding().settlement;

Sleep(rand(500) + 1000);

while (1) {
	ol = .Units.ObjClass("Peasant");
	ol.ClearDead();
	ol = ol.ObjAlly(.player);
	if (ol.count > 0) {
		Unit u;
		ol[rand(ol.count)].Erase();
		u = Place("HHoplite", This.pos, .player);
		.ForceAddUnit(u);
	}
	Sleep(20000);
}