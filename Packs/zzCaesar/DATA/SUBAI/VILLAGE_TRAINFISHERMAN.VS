//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement supplied;
	Obj o;
	point pt_dest;
	int i;

	i = .radius;

	pt_dest.SetLen(rand(GetConst("VillageTrainPeasantRadius") - i) + i);
	pt_dest.Rot(rand(360));
	pt_dest = pt_dest + .pos;

	i = .player;
	o = Place("Fisherman", .GetExitPoint(pt_dest, false), i);

	supplied = .settlement.supplied;

	if (supplied.IsValid)
		if (supplied.IsShipyard)
			if (!supplied.IsEnemy(i)) {
				o.SetCommand("enter", supplied.GetCentralBuilding());
				return;
			}

	o.SetCommand("move", pt_dest);
}