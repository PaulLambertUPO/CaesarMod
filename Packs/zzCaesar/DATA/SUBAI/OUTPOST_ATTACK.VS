//void, Obj This, Obj target

if (target.AsUnit().IsValid)
	if (target.IsAlive) {
		Settlement this;

		this = This.AsBuilding().settlement;

		if (!.IsIndependent) {
			ObjList blds;
			Tower t;
			int i;

			blds = .Buildings;

			for (i = blds.count - 1; i >= 0; i -= 1) {
				t = blds[i].AsTower();
				if (t.IsValid)
					if (t.IsHeirOf("FakeTower"))
						if (t.CanAttack(target))
							t.SetCommand("attack", target);
			}
		}
	}