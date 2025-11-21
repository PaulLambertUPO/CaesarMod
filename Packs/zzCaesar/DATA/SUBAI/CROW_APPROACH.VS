//void, Obj This, Obj other

Flying this;

this = This.AsFlying();

if (.IsValid)
	if (other.IsValid) {
		point pt, dir, vec, pt_fly;
		int angle, terr_h;
		bool fly_to_target = false;

		pt = other.posRH;
		dir = .dir;

		angle = MapSize;
		pt.Set(CLAMP(pt.x, 0, angle), CLAMP(pt.y, 250, angle - 675));//keep crows away from UI bars at top/bottom edges, which hide them

		while (!.IsInState)
			Sleep(50);

		.SetUser(0);

		while (.DistTo(pt) > 100) {
			if (!fly_to_target) {//rotate
				vec = pt - .pos;//relative pos

				if (OnLeft(dir, vec)) {
					angle = GetAngleByDir(dir) - 30;
					if (angle < 0)
						angle += 360;
					if (!OnLeft(dir + GetDirByAngle(angle), vec))
						fly_to_target = true;
				}
				else {
					angle = GetAngleByDir(dir) + 30;
					if (OnLeft(dir + GetDirByAngle(angle), vec))
						fly_to_target = true;
				}

				if (fly_to_target)
					dir = pt - .pos;
				else {
					if (.IsInAir)
						pt_fly = .pos + GetVecByDir(dir, 75);
					else
						pt_fly = .pos + GetVecByDir(dir, 120);

					terr_h = GetTerrainHeight(pt_fly);

					if (.IsInAir)
						.PlayAnim(0, pt_fly, CLAMP(.z, terr_h + 80, terr_h + 120));
					else
						.PlayAnim(16, pt_fly, terr_h + 80);

					dir = GetDirByAngle(angle);//rotate
				}
			}
			if (fly_to_target) {
				if (.IsInAir)
					pt_fly = .pos + GetVecByDir(dir, 75);
				else
					pt_fly = .pos + GetVecByDir(dir, 120);

				terr_h = GetTerrainHeight(pt_fly);

				if (.IsInAir)
					.PlayAnim(0, pt_fly, CLAMP(.z, terr_h + 80, terr_h + 120));
				else
					.PlayAnim(16, pt_fly, terr_h + 80);
			}
		}

		pt_fly = .PickLandingPoint(120);
		if (pt_fly.x >= 0) {//careful landing and transition to idle
			.PlayAnim(17, pt_fly, -1);
			.PlayAnim(18, .pos, -1);
		}
	}