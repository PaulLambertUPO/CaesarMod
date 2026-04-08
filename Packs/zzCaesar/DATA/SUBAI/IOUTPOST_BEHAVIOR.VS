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
	Unit u;
	int i;

	while (true) {
		Sleep(10000);
		if (!hall.IsBroken)
			if (!.IsIndependent) {
				ol = .Units;
				for (i = ol.count - 1; i >= 0; i -= 1) {
					u = ol[i].AsUnit();
					if (u.IsAlive)
						if (!.IsEnemy(u.player))
							if (u.inherentlevel < 8)
								u.SetExperience(u.experience + 1);
				}
			}
	}
}