//void, Obj This, Obj other

Wagon this;

this = This.AsWagon();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

		bld = other.AsBuilding();

		if (bld.IsValid)
			if (bld.IsCentralBuliding)
				if (!.IsEnemy(bld)) {
					Settlement set;
					bool carry_food, can_enter = false;

					set = bld.settlement;
					carry_food = .restype == 1;

					if (carry_food) {
						if (set.max_food > 0)
							can_enter = true;
					}
					else if (set.max_gold > 0)//note that tents have 0 so it is not needed to use IsHeirOf/IsTTent
						can_enter = true;

					if (can_enter) {
						point pt;

						.SetEntering(true);

						pt = bld.GetEnterPoint(this);
						while (!.GotoEnter(pt, 0, 2000, false, 2500))
							if (.IsEnemy(bld))
								break;

						if (carry_food)
							set.SetFood(set.food + .amount);
						else
							set.SetGold(set.gold + .amount);

						.SetFood(0);
						.SetGold(0);
						.Erase();
					}
				}
	}

Sleep(15);//avoid possible loops with other commands