//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (.max_items > 0) {
			ItemHolder holder;

			holder = other.AsItemHolder();

			if (holder.IsValid) {
				if (IsAIPlayer(.player))
					.SetParryMode(false);

				while (!.Goto(holder, 25, 2500, false, 5000))
					if (!holder.IsValid)
						break;

				if (holder.IsValid)
					if (.OpenItemHolder(holder)) {
						if (.HasSpecial(sneak))
							.SetLastAttackTime();
						if (!.IsVisible)
							.SetVisible(true);
					}
			}
		}
		else
			.AddCommand(true, "approach", other);

Sleep(15);//prevent possible loops with other commands