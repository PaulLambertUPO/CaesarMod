//bool, Obj This, Obj other

Wagon this;

this = This.AsWagon();

if (.IsValid)
	if (.IsAlive) {
		Building bld;

		bld = other.AsBuilding();

		if (bld.IsValid)
			if (bld.IsCentralBuliding)
				if (!.IsEnemy(bld))
					if (.restype == 1) {
						if (bld.settlement.max_food > 0)
							return true;
					}
					else if (bld.settlement.max_gold > 0)//note that tents have 0 so it is not needed to use IsHeirOf/IsTTent
						return true;
	}

return false;