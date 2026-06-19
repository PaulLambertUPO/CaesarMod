//void, Obj this

.Progress();

{
	Settlement set;
	point pt_place;
	int i, plr;

	set = .AsBuilding().settlement;
	plr = .player;

	if (set.IsStronghold) {
		pt_place = .pos;

		for (i = 0; i < 10; i += 1)
			set.ForceAddUnit(Place("MercenaryGHorseman", pt_place, plr).AsUnit());
		for (i = 0; i < 20; i += 1)
			set.ForceAddUnit(Place("MercenaryHHoplite", pt_place, plr).AsUnit());
		for (i = 0; i < 20; i += 1)
			set.ForceAddUnit(Place("MercenaryISlinger", pt_place, plr).AsUnit());
	}
	else {
		pt_place = set.GetCentralBuilding().GetExitPoint(.pos, false);

		for (i = 0; i < 10; i += 1)
			Place("MercenaryGHorseman", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
		for (i = 0; i < 20; i += 1)
			Place("MercenaryHHoplite", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
		for (i = 0; i < 20; i += 1)
			Place("MercenaryISlinger", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
	}
}