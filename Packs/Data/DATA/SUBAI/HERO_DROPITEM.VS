//void, Obj This, Item item, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		if (Dist(.posRH, pt) >= 1000) {
			.FormSetupAndMoveTo(pt, 0, 0, true);
			while (.HasPath) {
				if (.GetItemIndex(item) == -1)
					break;
				if (.DistTo(pt) < 1000)
					break;
				.FormKeepMoving(1500);
			}
		}

		.army.SetCommand("idle");

		while (!.Goto(pt, 25, 2500, false, 5000))
			if (.GetItemIndex(item) == -1)
				break;

		if (.DropItem(item, pt)) {
			if (.HasSpecial(sneak))
				.SetLastAttackTime();
			if (!.IsVisible)
				.SetVisible(true);
		}
	}

Sleep(15);//prevent possible loops with other commands