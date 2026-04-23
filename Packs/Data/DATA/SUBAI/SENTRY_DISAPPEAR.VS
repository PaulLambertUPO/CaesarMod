//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Building wall;

		wall = other.AsBuilding();

		if (wall.IsValid)
			if (wall.player == .player)
				wall.settlement.PutSentry();

		.AddCommand(true, "dismiss");

		.Disappear();

		.Mutate("SentryDismiss");
	}