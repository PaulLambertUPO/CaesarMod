//void, Obj This, Obj ToBoard

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive) {
		Unit u, u_other;
		point pt;
		int rad, spd, dist;
		bool ship_moved;

		rad = .radius;
		spd = .speed;

		u = ToBoard.AsUnit();
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

			if (!u.AsFlying().IsValid) {//flying units cause a crash
				ship_moved = false;

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

				while (!.GotoEnter(pt, 0, 1200, true, -1)) {
					ship_moved = true;
					u_other = .BestCandidateToBoard;
					if (u_other != u)
						if (u_other.IsAlive)
							if (!u_other.AsFlying().IsValid)//flying units cause a crash
								u = u_other;
					if (u.IsDead)
						break;
					if (.TimeWithoutWalking > 0)
						break;
					if (.NumUnitsToBoard <= 0) {
						Sleep(15);//prevent possible loops with other commands
						return;
					}
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

				while (1) {
					if (u.IsDead)
						break;
					if (ship_moved)
						if (.DistTo(u.pos) > 500)
							break;
					Sleep(100);
				}
			}

			Sleep(100);
		}
	}

Sleep(15);//prevent possible loops with other commands