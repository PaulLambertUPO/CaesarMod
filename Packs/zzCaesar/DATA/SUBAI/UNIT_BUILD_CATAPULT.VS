//void, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Catapult catap;

		catap = other.AsCatapult();

		if (catap.IsValid)
			if (catap.IsAlive) {
				point pt;

				.SetParryMode(false);

				if (.hero.IsValid)
					.DetachFrom(.hero);

				pt = catap.GetEnterPoint(this);

				.SetEntering(true);

				while (!.GotoEnter(pt, 0, 1000, false, 2500))
					if (catap.IsDead)
						break;

				if (catap.IsAlive)
					if (!.IsEnemy(catap))
						if (DiplGetShareView(catap.player, .player))
							if (catap.settlement.AddUnit(this)) {
								Sleep(15);//prevent possible loops with other commands
								return;
							}

				.AddCommand(true, "move", pt + RandomOffset(2));//avoid moving all units to the same place
			}
	}

Sleep(15);//prevent possible loops with other commands