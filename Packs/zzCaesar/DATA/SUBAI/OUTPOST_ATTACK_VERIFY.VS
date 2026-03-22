//bool, Obj this, Obj other

if (other.AsUnit().IsValid)
	if (other.IsAlive) {
		Settlement set;

		set = .AsBuilding().settlement;

		if (!set.IsIndependent)
			if (set.UnitsCount > 0)
				if (.IsEnemy(other)) {
					ObjList blds;
					Tower t;
					int i;

					blds = set.Buildings;

					for (i = blds.count - 1; i >= 0; i -= 1) {
						t = blds[i].AsTower();
						if (t.IsValid) 
							if (t.IsHeirOf("FakeTower"))
								if (t.CanAttack(other))
									return true;
					}
				}
	}

return false;