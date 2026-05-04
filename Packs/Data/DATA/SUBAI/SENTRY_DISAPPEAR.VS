//void, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive) {
		Building wall;

		wall = other.AsBuilding();

		if (wall.IsValid)
			if (wall.player == .player)
				wall.settlement.PutSentry();

		.Erase();
	}