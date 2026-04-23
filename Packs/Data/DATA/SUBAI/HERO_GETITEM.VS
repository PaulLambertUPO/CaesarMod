//void, Obj This, Item item, Obj holder

if (holder.AsItemHolder().IsValid) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive) {
			if (holder.DistTo(.posRH) >= 600) {
				.FormSetupAndMoveTo(holder.pos, 0, 0, true);
				while (.HasPath) {
					if (!holder.IsValid)
						break;
					if (.DistTo(holder) < 600)
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
					if (holder.GiveItem(item, this)) {
						if (.HasSpecial(sneak))
							.SetLastAttackTime();
						if (!.IsVisible)
							.SetVisible(true);
					}
			}
		}
}

Sleep(15);//prevent possible loops with other commands