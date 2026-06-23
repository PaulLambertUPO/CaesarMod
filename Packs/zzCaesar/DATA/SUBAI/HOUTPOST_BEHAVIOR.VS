//void, Obj This

Settlement this;
Building hall;

hall = This.AsBuilding();

this = hall.settlement;

Sleep(1000 + rand(1001));

while (.IsIndependent)
	Sleep(2000);

{
	ObjList ol;

	while (true) {
		Sleep(40000);
		if (!hall.IsBroken)
			if (!.IsIndependent) {
				ol = .Units.ObjClass("Peasant").ObjAlly(.player);
				if (ol.count > 0)
					ol[rand(ol.count)].AsUnit().Mutate("HHopliteMercenary");
			}
	}
}