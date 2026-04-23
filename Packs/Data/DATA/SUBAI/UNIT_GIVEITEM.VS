//void, Obj This, Item item, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		u = other.AsUnit();

		if (u.IsValid)
			if (u.IsAlive)
				if (u.max_items > 0)
					if (!.IsEnemy(u))
						if (!u.InHolder) {
							if (IsAIPlayer(.player))
								.SetParryMode(false);

							while (!.Goto(u, 25, 2500, false, 5000)) {
								if (u.IsDead)
									break;
								if (.IsEnemy(u))
									break;
								if (u.InHolder)
									break;
								if (.GetItemIndex(item) == -1)
									break;
							}

							if (u.IsAlive)
								if (!.IsEnemy(u))
									if (!u.InHolder)
										if (.GiveItem(item, u)) {
											if (.HasSpecial(sneak))
												.SetLastAttackTime();
											if (!.IsVisible)
												.SetVisible(true);
										}
						}
	}

Sleep(15);//prevent possible loops with other commands