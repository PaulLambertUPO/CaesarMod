//void, Obj This, Item item, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		ItemHolder holder;

		holder = other.AsItemHolder();

		if (holder.IsValid) {
			if (.AI)
				.SetParryMode(false);

			while (!.Goto(holder, 25, 2500, false, 5000)) {
				if (!holder.IsValid)
					break;
				if (.GetItemIndex(item) == -1)
					break;
			}

			if (holder.IsValid)
				if (.PutItem(item, holder)) {
					if (.HasSpecial(sneak))
						.SetLastAttackTime();
					if (!.IsVisible)
						.SetVisible(true);
				}
		}
	}

Sleep(30);//prevent possible loops with other commands