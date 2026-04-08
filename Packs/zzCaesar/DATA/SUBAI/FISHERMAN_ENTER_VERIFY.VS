//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive)
		if (other.AsBuilding().IsValid) {
			if (other.AsTeleport().IsValid)
				return true;

			if (other.IsHeirOf("BaseShipyard"))
				if (!.IsEnemy(other))
					return true;
		}

return false;