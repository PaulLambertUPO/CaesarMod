//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive)
		if (other.AsBuilding().IsValid) {
			if (other.AsTeleport().IsValid)
				return true;

			if (other.IsHeirOf("IVillage"))
				if (!.IsEnemy(other))
					return true;
		}

return false;