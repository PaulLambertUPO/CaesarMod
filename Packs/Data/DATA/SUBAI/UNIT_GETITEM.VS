//void, Obj This, Item item, Obj holder

if (holder.AsItemHolder().IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (.max_items > 0) {
				if (.AI)
					.SetParryMode(false);

				while (!.Goto(holder, 25, 2500, false, 5000))
					if (!holder.IsValid)
						break;

				if (holder.IsValid)
					if (holder.GiveItem(item, this)) {
						if (.HasSpecial(sneak))
							.SetLastAttackTime();
						if (!.IsVisible)
							.SetVisible(true);
					}
			}
}

Sleep(30);//prevent possible loops with other commands