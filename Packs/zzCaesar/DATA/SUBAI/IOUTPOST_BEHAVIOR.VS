//void, Obj This

Settlement this;
Building hall;
ObjList ol;
Unit u;
int i;

hall = This.AsBuilding();

this = hall.settlement;

Sleep(rand(501) + 1000);

while (.IsIndependent)
	Sleep(2000);

while (1) {
	Sleep(10000);
	if (!hall.IsBroken)
		if (!.IsIndependent) {
			ol = .Units;
			for (i = 0; i < ol.count; i += 1) {
				u = ol[i].AsUnit();
				if (u.IsValid)
					if (!.IsEnemy(u.player))
						if (u.inherentlevel < 8)
							u.SetExperience(u.experience + 1);
			}
		}
}