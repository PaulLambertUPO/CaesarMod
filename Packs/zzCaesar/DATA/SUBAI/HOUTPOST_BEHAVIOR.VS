//void, Obj This

Settlement this;
Building hall;
ObjList ol;

hall = This.AsBuilding();

this = hall.settlement;

Sleep(rand(501) + 1000);

while (.IsIndependent)
	Sleep(2000);

while (1) {
	Sleep(40000);
	if (!hall.IsBroken)
		if (!.IsIndependent) {
			ol = .Units.ObjClass("Peasant").ObjAlly(.player);
			if (ol.count > 0)
				ol[rand(ol.count)].AsUnit().Mutate("HHoplite");
		}
}