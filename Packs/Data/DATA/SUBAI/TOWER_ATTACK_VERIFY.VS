//bool, Obj this, Obj other

Settlement set;

set = .AsBuilding().settlement;

if (set.IsOutpost)
	if (set.IsIndependent)
		return false;

if (set.UnitsCount > 0)
	if (other.IsValid)
		if (other.IsAlive)
			if (.IsValidTarget(other))
				if (.CanAttack(other))
					return true;

return false;