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
			set.ForceAddUnit(Place("GHorsemanMercenary", pt_place, plr).AsUnit());
		for (i = 0; i < 20; i += 1)
			set.ForceAddUnit(Place("HHopliteMercenary", pt_place, plr).AsUnit());
		for (i = 0; i < 20; i += 1)
			set.ForceAddUnit(Place("ISlingerMercenary", pt_place, plr).AsUnit());
	}
	else {
		pt_place = set.GetCentralBuilding().GetExitPoint(.pos, false);

		for (i = 0; i < 10; i += 1)
			Place("GHorsemanMercenary", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
		for (i = 0; i < 20; i += 1)
			Place("HHopliteMercenary", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
		for (i = 0; i < 20; i += 1)
			Place("ISlingerMercenary", pt_place, plr).SetCommand("advance", RandomPointInCircle(pt_place, 450));
	}
}