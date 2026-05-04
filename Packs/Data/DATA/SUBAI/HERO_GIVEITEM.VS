//void, Obj This, Item item, Obj other

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive) {
		Unit u;

		u = other.AsUnit();

		if (u.IsValid)
			if (u.IsAlive)
				if (u.max_items > 0)
					if (!.IsEnemy(u))
						if (!u.InHolder) {
							point pt_army_follow;

							if (u.DistTo(.posRH) >= 1000) {
								.FormSetupAndMoveTo(u.pos, 0, 0, true);
								while (.HasPath) {
									.FormKeepMoving(1500);
									if (u.IsDead)
										break;
									if (.IsEnemy(u))
										break;
									if (u.InHolder)
										break;
									if (.GetItemIndex(item) == -1)
										break;
									if (.DistTo(u) < 1000)
										break;
									.FormSetupAndMoveTo(u.pos, 0, 0, true);
								}
							}

							.army.SetCommand("idle");

							pt_army_follow = .posRH;

							while (!.Goto(u, 25, 2500, false, 5000)) {
								if (u.IsDead)
									break;
								if (.IsEnemy(u))
									break;
								if (u.InHolder)
									break;
								if (.GetItemIndex(item) == -1)
									break;
								if (.DistTo(pt_army_follow) >= 1000) {
									pt_army_follow = .pos;
									.army.SetCommand("advance", pt_army_follow);
								}
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

Sleep(30);//prevent possible loops with other commands