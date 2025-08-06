//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement supplied;
	Unit u;
	point pt_dest;
	int radius, player;

	radius = .radius;
	player = .player;

	pt_dest.Set(1, 1);
	pt_dest.SetLen(rand(GetConst("VillageTrainPeasantRadius") - radius) + radius);
	pt_dest.Rot(rand(360));
	pt_dest = pt_dest + .pos;

	u = Place("Fisherman", .GetExitPoint(pt_dest, false), player);

	supplied = .settlement.supplied;

	if (supplied.IsValid)
		if (supplied.IsShipyard)
			if (!supplied.IsEnemy(player)) {
				u.SetCommand("enter", supplied.GetCentralBuilding());
				return;
			}

	u.SetCommand("move", pt_dest);
}