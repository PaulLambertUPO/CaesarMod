//void, Obj This, point pt

Flying this;

this = This.AsFlying();

if (.IsValid)
	if (.IsAlive) {
		point new_pos;
		int i, dist, start, min = 2000000;//radius = 1800

		//find closest point to the hovering circle
		for (i = 0; i < 32; i += 1) {
			dist = .DistTo(pt + GetVecByDir(GetDirByAngle(360 * i / 32), 1800));
			if (dist < min) {
				min = dist;
				start = i;
			}
		}

		.AddCommand(true, "hover", pt);

		new_pos = pt + GetVecByDir(GetDirByAngle(360 * (start - 4) / 32), 1800);
		.AddCommand(true, "move", new_pos);

		new_pos = pt + GetVecByDir(GetDirByAngle(360 * (start + 21) / 32), 1800);
		.AddCommand(true, "move", new_pos);

		new_pos = pt + GetVecByDir(GetDirByAngle(360 * (start + 10) / 32), 1800);
		.AddCommand(true, "move", new_pos);

		new_pos = pt + GetVecByDir(GetDirByAngle(360 * start / 32), 1800);
		.AddCommand(true, "move", new_pos);
	}