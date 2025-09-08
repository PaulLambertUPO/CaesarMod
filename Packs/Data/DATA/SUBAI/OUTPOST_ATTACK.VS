//void, Obj This, Obj target

Settlement this;

this = This.AsBuilding().settlement;

if (!.IsIndependent)
	if (target.AsUnit().IsValid) {
		ObjList blds;
		Tower t;
		int i;

		blds = .Buildings;

		for (i = 0; i < blds.count; i += 1) {
			t = blds[i].AsTower();
			if (t.IsValid)
				if (t.IsHeirOf("FakeTower"))
					if (t.CanAttack(target))
						t.SetCommand("attack", target);
		}
	}