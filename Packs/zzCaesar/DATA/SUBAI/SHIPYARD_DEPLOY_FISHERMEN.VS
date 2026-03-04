//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Settlement set, supplied;
	Obj o;
	point pt_pos, pt_inverted_exit_vec, pt_dest;
	int i, j, plr, rad;

	set = .settlement;
	pt_pos = .pos;
	plr = .player;
	rad = .radius + 120;

	pt_inverted_exit_vec = .GetExitVector() * -1;

	for (i = EnvReadInt(set, "Fishermen"); i > 0; i -= 1) {
		if (j >= 5)
			return;

		pt_dest = pt_inverted_exit_vec;
		pt_dest.SetLen(rad + rand(41));
		pt_dest.Rot(rand(31) - 15);
		pt_dest = pt_dest + pt_pos;

		o = Place("Fisherman", .GetExitPoint(pt_dest, false), plr);

		EnvWriteInt(set, "Fishermen", i - 1);
		j += 1;

		supplied = set.supplied;//reassign every time because it can change during the sleeps

		if (supplied.IsValid)
			if (supplied.IsShipyard)
				if (!supplied.IsEnemy(plr)) {
					o.SetCommand("enter", supplied.GetCentralBuilding());
					Sleep(100);
					continue;
				}

		o.SetCommand("move", pt_dest);
		Sleep(100);
	}
}