//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (other.AsBuilding().IsValid)
		if (other.IsHeirOf("BaseShipyard"))
			if (!.IsEnemy(other))
				return true;

return false;