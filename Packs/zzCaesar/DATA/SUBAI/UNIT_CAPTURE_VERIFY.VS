//bool, Obj this, Obj other

if (.IsMilitary)
	if (.IsEnemy(other))
		if (other.AsBuilding().IsValid()) {
			if (.IsValidCaptureTarget(other))
				return true;
		}
		else if (other.IsHeirOf("Wagon"))
			return true;
		else if (other.IsHeirOf("WildHorse"))
			if (IsResearched(.player, "Tame horses"))
				return true;

return false;