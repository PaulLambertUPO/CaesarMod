//void, Obj This, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		ItemHolder holder;

		holder = other.AsItemHolder();

		if (holder.IsValid) {
			if (holder.DistTo(.posRH) >= 750) {
				.FormSetupAndMoveTo(holder.pos, 0, 0, true);
				while (.HasPath) {
					if (!holder.IsValid)
						break;
					if (.DistTo(holder) < 750)
						break;
					.FormKeepMoving(1500);
				}
			}

			.army.SetCommand("idle");

			if (holder.IsValid) {
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
	}

Sleep(30);//prevent possible loops with other commands