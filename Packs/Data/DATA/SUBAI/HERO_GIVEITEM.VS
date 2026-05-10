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
							point pt_pos;

							if (u.DistTo(.posRH) >= 1000) {
								pt_pos = u.pos;
								.FormSetupAndMoveTo(pt_pos, 0, 0, true);
								while (.HasPath) {
									.FormKeepMoving(1000);
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
									if (u.DistTo(pt_pos) > 350) {//avoid moving the army every time or it risks messing up with obstacles nearby
										pt_pos = u.pos;
										.FormSetupAndMoveTo(pt_pos, 0, 0, true);
									}
								}
							}

							.army.SetCommand("idle");

							pt_pos = .posRH;

							while (!.Goto(u, 25, 2500, false, 5000)) {
								if (u.IsDead)
									break;
								if (.IsEnemy(u))
									break;
								if (u.InHolder)
									break;
								if (.GetItemIndex(item) == -1)
									break;
								if (.DistTo(pt_pos) >= 1000) {
									pt_pos = .pos;
									.army.SetCommand("advance", pt_pos);
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