//void, Obj this

.Progress();

{
	Settlement set;
	point pt_pos;
	int i, plr;

	set = .AsBuilding().settlement;
	pt_pos = .pos;
	plr = .player;

	for (i = 0; i < 10; i += 1)
		set.ForceAddUnit(Place("MercenaryGHorseman", pt_pos, plr).AsUnit());
	for (i = 0; i < 20; i += 1)
		set.ForceAddUnit(Place("MercenaryHHoplite", pt_pos, plr).AsUnit());
	for (i = 0; i < 20; i += 1)
		set.ForceAddUnit(Place("MercenaryISlinger", pt_pos, plr).AsUnit());
}