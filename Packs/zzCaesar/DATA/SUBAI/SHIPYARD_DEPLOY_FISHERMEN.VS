//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement set, supplied;
	Unit u;
	point pos, pt_inverted_exit_vec, pt_dest;
	int i, j, radius, player;

	set = .settlement;
	pos = .pos;
	radius = .radius;
	player = .player;

	pt_inverted_exit_vec = .GetExitVector() * -1;

	for (i = EnvReadInt(set, "Fishermen"); i > 0 && j < 5; i -= 1) {
		pt_dest = pt_inverted_exit_vec;
		pt_dest.SetLen(radius + 120 + rand(41));
		pt_dest.Rot(rand(31) - 15);
		pt_dest = pt_dest + pos;

		u = Place("Fisherman", .GetExitPoint(pt_dest, false), player);

		EnvWriteInt(set, "Fishermen", i - 1);
		j += 1;

		supplied = .settlement.supplied;

		if (supplied.IsValid)
			if (supplied.IsShipyard)
				if (!supplied.IsEnemy(player)) {
					u.SetCommand("enter", supplied.GetCentralBuilding());
					Sleep(100);
					continue;
				}

		u.SetCommand("move", pt_dest);
		Sleep(100);
	}
}