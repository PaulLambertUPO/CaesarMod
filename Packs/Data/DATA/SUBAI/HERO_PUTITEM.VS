//void, Obj This, Item item, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		ItemHolder holder;

		holder = other.AsItemHolder();

		if (holder.IsValid) {
			if (holder.DistTo(.posRH) >= 1000) {
				.FormSetupAndMoveTo(holder.pos, 0, 0, true);
				while (.HasPath) {
					if (!holder.IsValid)
						break;
					if (.GetItemIndex(item) == -1)
						break;
					if (.DistTo(holder) < 1000)
						break;
					.FormKeepMoving(1500);
				}
			}

			.army.SetCommand("idle");

			if (holder.IsValid) {
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
	}

Sleep(15);//prevent possible loops with other commands