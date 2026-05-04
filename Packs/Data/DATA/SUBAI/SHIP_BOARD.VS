//void, Obj This, Obj target

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		int max_units;

		max_units = .UnitsMax;

		if (.UnitsCount < max_units) {
			Unit u, u_other;
			point pt;
			int rad, spd, dist;

			rad = .radius;
			spd = .speed;

			u = target.AsUnit();
			if (u.IsValid)
				if (u.IsAlive)
					if (!u.AsFlying().IsValid) {//flying units cause a crash
						.NotifyBoardUnit(u);
						if (u.AsHero().IsValid)
							u.SetCommand("boardshiphero", this);
						else
							u.SetCommand("boardship", this);
					}

			while (.AreUnitsToBoard) {
				u = .BestCandidateToBoard;

				pt = u.PathDestFound;
				if (pt.x != -1) {
					dist = .DistTo(u.pos);
					if (dist < .DistTo(pt))
						pt = u.pos;
					else if ((dist + rad) * u.speed < (u.DistTo(pt) + u.radius) * spd)
						pt = u.pos;
				}
				else
					pt = u.pos;

				while (!.GotoEnter(pt, 0, 1000, false, -1)) {
					if (.UnitsCount >= max_units) {
						Sleep(30);//prevent possible loops with other commands
						return;
					}
					if (.NumUnitsToBoard <= 0) {
						Sleep(30);//prevent possible loops with other commands
						return;
					}
					u_other = .BestCandidateToBoard;
					if (u_other != u)
						if (u_other.IsAlive)
							u = u_other;
					if (u.IsDead)
						break;
					if (.TimeWithoutWalking > 0)
						break;
					pt = u.PathDestFound;
					if (pt.x != -1) {
						dist = .DistTo(u.pos);
						if (dist < .DistTo(pt))
							pt = u.pos;
						else if ((dist + rad) * u.speed < (u.DistTo(pt) + u.radius) * spd)
							pt = u.pos;
					}
					else
						pt = u.pos;
				}

				for (dist = 0; dist < 8; dist += 1) {
					if (u.IsDead)
						break;
					if (u.InShip)
						break;
					if (.DistTo(u.pos) > 500)
						break;
					Sleep(500);
				}

				Sleep(500);

				if (.UnitsCount >= max_units)
					break;
			}
		}
	}

Sleep(30);//prevent possible loops with other commands