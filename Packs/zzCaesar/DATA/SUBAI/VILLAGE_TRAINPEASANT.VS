//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement set, supplied;
	Obj o;
	StrArray villager_classes;
	point pt_pos, pt_dest, pt_place;
	int i, plr, rad;

	set = .settlement;
	pt_pos = .pos;
	i = .radius;
	plr = .player;
	rad = rand(GetConst("VillageTrainPeasantRadius") - i) + i;

	if (.race == ImperialRome) {
		villager_classes[0] = "HVillager";
		villager_classes[1] = "HWVillager";
	}
	else {
		villager_classes[0] = .raceStrPref + "Villager";
		villager_classes[1] = .raceStrPref + "WVillager";
	}

	for (i = GetConst("PopGroup"); i > 0; i -= 1) {
		pt_dest.Set(1, 1);
		pt_dest.SetLen(rad);
		pt_dest.Rot(rand(360));
		pt_dest = pt_dest + pt_pos;

		pt_place = .GetExitPoint(pt_dest, false);

		if (i == 5)
			pt_place.Set(pt_place.x + 10, pt_place.y + 10);
		else if (i == 4)
			pt_place.Set(pt_place.x - 10, pt_place.y - 10);
		else if (i == 3)
			pt_place.Set(pt_place.x - 10, pt_place.y + 10);
		else if (i == 2)
			pt_place.Set(pt_place.x + 10, pt_place.y - 10);

		o = Place(villager_classes[rand(2)], pt_place, plr);

		supplied = set.supplied;//reassign every time because it can change during the sleeps

		if (supplied.IsValid)
			if (!supplied.IsTTent)
				if (!supplied.IsShipyard)
					if (!supplied.IsEnemy(plr)) {
						o.SetCommand("enter", supplied.GetCentralBuilding());
						Sleep(100);
						continue;
					}

		o.SetCommand("move", pt_dest);
		Sleep(100);
	}
}