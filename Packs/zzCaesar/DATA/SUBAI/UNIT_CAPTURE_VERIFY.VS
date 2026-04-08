//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive)
		if (other.IsValid)
			if (.IsEnemy(other))
				if (other.AsBuilding().IsValid) {
					if (.IsValidCaptureTarget(other))
						return true;
				}
				else if (other.IsAlive) {
					if (other.AsWagon().IsValid)
						return true;

					if (other.IsHeirOf("WildHorse"))
						if (IsResearched(.player, "Tame horses"))
							return true;
				}

return false;