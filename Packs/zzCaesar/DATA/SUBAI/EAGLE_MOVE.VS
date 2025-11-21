//void, Obj This, point pt

Flying this;

this = This.AsFlying();

if (.IsValid) {
	point dir, vec, pt_fly;
	int duration_anim_4, duration_anim_0, angle, terr_h, anim_idx;
	bool fly_to_target = false;

	dir = .dir;

	duration_anim_4 = .GetAnimDuration(4);
	duration_anim_0 = .GetAnimDuration(0);

	angle = MapSize;
	pt.Set(CLAMP(pt.x, 0, angle), CLAMP(pt.y, 250, angle - 675));//keep eagles away from UI bars at top/bottom edges, which hide them

	while (!.IsInState)
		Sleep(50);

	while (.DistTo(pt) > 100) {
		if (!fly_to_target) {//rotate
			vec = pt - .pos;//relative pos

			if (OnLeft(dir, vec)) {
				angle = GetAngleByDir(dir) - 30;
				if (angle < 0)
					angle += 360;
				if (!OnLeft(dir + GetDirByAngle(angle), vec))
					fly_to_target = true;
				anim_idx = 17;
			}
			else {
				angle = GetAngleByDir(dir) + 30;
				if (OnLeft(dir + GetDirByAngle(angle), vec))
					fly_to_target = true;
				anim_idx = 18;
			}

			if (fly_to_target)
				dir = pt - .pos;
			else {
				pt_fly = .pos + GetVecByDir(dir, .speed / 2);
				terr_h = GetTerrainHeight(pt_fly);

				.PlayAnim(anim_idx, pt_fly, CLAMP(.z, terr_h + 150, terr_h + 300));

				dir = GetDirByAngle(angle);//rotate
			}
		}
		if (fly_to_target) {
			if (rand(5) == 0) {
				anim_idx = 0;
				pt_fly = .pos + GetVecByDir(dir, .speed);
			}
			else {
				anim_idx = 4;
				pt_fly = .pos + GetVecByDir(dir, .speed * duration_anim_4 / duration_anim_0);
			}

			terr_h = GetTerrainHeight(pt_fly);

			.PlayAnim(anim_idx, pt_fly, CLAMP(.z, terr_h + 150, terr_h + 300));
		}
	}
}