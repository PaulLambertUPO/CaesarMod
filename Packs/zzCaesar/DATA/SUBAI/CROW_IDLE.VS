//void, Obj This

Flying this;//note: user = 1 means that the flying crow has to land

this = This.AsFlying();

if (.IsValid)
	if (.IsAlive) {
		Query crows, units, buildings;
		ObjList ol;
		Obj near_bird;
		Flying f;
		point pt_fly;
		int i, j, this_z, target_z, behaviour;
		bool fly;

		crows = ObjsInRange(this, "Crow", 900);
		units = ObjsInRange(this, "Unit", 550);
		buildings = ObjsInRange(this, "Building", 550);

		Sleep(500 + rand(2001));

		while (.CmdCount <= 1)//avoid blocking pending commands forever
			if (.InHolder)
				Sleep(10000);
			else {
				if (!.IsInAir) {
					j = 0;
					fly = false;
					while (true) {//join other flying crows or fly away from other units
						j += 1;
						.Idle(1300);

						ol = crows.GetObjList();
						for (i = ol.count - 1; i >= 0; i -= 1) {
							f = ol[i].AsFlying();
							if (f.IsAlive)
								if (f.IsInAir) {
									if (f.user == 1) {
										fly = false;
										break;
									}
									fly = true;
								}
						}

						if (fly)
							break;

						if (j > 30)
							if (rand(15) == 0)
								break;

						if (!units.IsEmpty)
							break;
					}
				}

				near_bird.Clear();
				if (crows.IsEmpty)
					near_bird = .FindNearBird();

				target_z = 260 + rand(100);
				if (near_bird.IsValid) {
					pt_fly = near_bird.pos - .pos;
					pt_fly.SetLen(100);
					.PlayAnim(16, .pos + pt_fly, GetTerrainHeight(.pos) + 80);
					behaviour = 0;
				}
				else {
					.PlayAnim(16, .PickFlyingPoint(120), GetTerrainHeight(.pos) + 80);
					behaviour = GetTime() / 10000 % 6;
					if (rand(5) == 0) {//chance to land at once
						.SetUser(1);
						target_z = 0;
					}
				}

				if (behaviour == 0)
					j = 30;
				else
					j = 0;

				while (true) {
					j += 1;

					pt_fly = .GetDir();
					if (behaviour == 0)
						if (rand(2) == 0)
							pt_fly.Rot(rand(10) - 5);
						else if (crows.IsEmpty)
							pt_fly.Rot(rand(8) - 4);
						else
							pt_fly = crows.GetAverageDirection();
					else if (behaviour == 3)
						pt_fly.Rot(-15 - rand(15));
					else
						pt_fly.Rot(15 + rand(15));
					pt_fly.SetLen(75);

					this_z = .z;
					if (this_z < target_z)
						this_z += 15 + rand(8);
					else if (this_z > target_z + 25)
						this_z -= 15 + rand(8);

					if (this_z < GetTerrainHeight(.pos + pt_fly) + 30)//too low, move higher
						this_z += 25;

					.AdjustFlyDir(pt_fly);
					.PlayAnim(0, .pos + pt_fly, this_z);

					if (units.IsEmpty)
						if (buildings.IsEmpty) {
							if (.user == 1)
								if (this_z <= GetTerrainHeight(.pos) + 60) {
									pt_fly = .PickLandingPoint(120);
									if (pt_fly.x >= 0)
										break;
								}

							ol = crows.GetObjList();
							for (i = ol.count - 1; i >= 0; i -= 1) {
								f = ol[i].AsFlying();
								if (f.IsAlive)
									if (f.user == 1) {
										.SetUser(1);
										target_z = 0;
										break;
									}
							}

							if (j > 160) {
								.SetUser(1);
								target_z = 0;
							}
							else if (j > 40)
								if (rand(25) == 0) {
									.SetUser(1);
									target_z = 0;
								}
						}

					if (j > 80)
						if (GetTime() / 5000 % 3 == 1)
							behaviour = 0;
				}

				//careful landing and transition to idle
				.PlayAnim(17, pt_fly, -1);
				.PlayAnim(18, .pos, -1);
				.SetUser(0);
			}
	}