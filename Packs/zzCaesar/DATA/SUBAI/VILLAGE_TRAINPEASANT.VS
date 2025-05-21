//void, Obj This

Building this;
Settlement supplied;
Unit unit;
StrArray villager_classes;
point pos, pt_dest, pt_place;
int i, radius, villager_train_radius, pop_group;

this = This.AsBuilding();

.Progress();

pos = .pos;
radius = .radius;
villager_train_radius = GetConst("VillageTrainPeasantRadius");
pop_group = GetConst("PopGroup");

if (.race == ImperialRome) {
	villager_classes[0] = "HVillager";
	villager_classes[1] = "HWVillager";
}
else {
	villager_classes[0] = .raceStrPref + "Villager";
	villager_classes[1] = .raceStrPref + "WVillager";
}

for (i = 0; i < pop_group; i += 1) {
	pt_dest.Set(1, 1);
	pt_dest.SetLen(rand(villager_train_radius - radius) + radius);
	pt_dest.Rot(rand(360));
	pt_dest = pt_dest + pos;

	pt_place = .GetExitPoint(pt_dest, false);

	if (i == 0)
		pt_place.Set(pt_place.x + 10, pt_place.y + 10);
	else if (i == 1)
		pt_place.Set(pt_place.x - 10, pt_place.y - 10);
	else if (i == 2)
		pt_place.Set(pt_place.x - 10, pt_place.y + 10);
	else if (i == 3)
		pt_place.Set(pt_place.x + 10, pt_place.y - 10);

	unit = Place(villager_classes[rand(2)], pt_place, .player).AsUnit();

	supplied = .settlement.supplied;

	if (supplied.IsValid)
		if (!supplied.IsTTent)
			if (!supplied.IsShipyard)
				if (!unit.IsEnemy(supplied.GetCentralBuilding())) {
					unit.SetCommand("enter", supplied.GetCentralBuilding());
					Sleep(100);
					continue;
				}
	unit.SetCommand("move", pt_dest);
	Sleep(100);
}