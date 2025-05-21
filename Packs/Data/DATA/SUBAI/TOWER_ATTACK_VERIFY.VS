//bool, Obj this, Obj other

Settlement sett; 
sett = .AsBuilding().settlement();

if (sett.IsOutpost())
	if (sett.IsIndependent)
		return false;

if (sett.UnitsCount() == 0)
	return false;

if (this.IsValidTarget(other))
	if (other.IsAlive())
		return .CanAttack(other);

return false;