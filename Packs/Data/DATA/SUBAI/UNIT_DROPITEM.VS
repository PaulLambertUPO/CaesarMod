//void, Obj This, Item item, point pt

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		if (IsAIPlayer(.player))
			.SetParryMode(false);

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