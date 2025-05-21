//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsHeirOf("Military")) {
		Building bld;

		bld = other.AsBuilding();

		if (bld.IsValid) {
			Settlement set;

			set = bld.settlement;

			if (set.IsOutpost)
				if (set.IsIndependentGuarded)
					return true;
			if (set.IsTTent)
				if (.IsEnemy(bld))
					return true;
		}
	}

return false;