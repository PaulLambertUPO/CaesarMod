ObjList ol;
Unit u;
int i;

{
	Building b;
	b = NO_Town1.obj.AsBuilding();
	b.Research("Heroes' Wisdom");
	b.Research("Warriors' Wisdom");
}

while (1) {
	ol = GetPlayerUnits(1, cMilitary);
	for (i = 0; i < ol.count; i += 1) {
		u = ol[i].AsUnit();
		if (u.IsValid())
			if (u.stamina >= u.maxstamina)
				if (u.health < u.maxhealth) {
					u.Heal(30);
					if (!u.InHolder)
						CreateFeedback("Heal", u);
				}
	}
	Sleep(5000);
}