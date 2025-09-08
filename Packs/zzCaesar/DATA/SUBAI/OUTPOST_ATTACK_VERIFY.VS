//bool, Obj this, Obj other

Settlement set;

set = .AsBuilding().settlement;

if (!set.IsIndependent)
	if (set.UnitsCount > 0)
		if (other.AsUnit().IsValid)
			if (other.IsAlive)
				if (.IsEnemy(other)) {
					ObjList blds;
					Tower t;
					int i;

					blds = set.Buildings;

					for (i = 0; i < blds.count; i += 1)  {
						t = blds[i].AsTower();
						if (t.IsValid) 
							if (t.IsHeirOf("FakeTower"))
								if (t.CanAttack(other))
									return true;
					}
				}

return false;