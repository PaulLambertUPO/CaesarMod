//bool, Obj this, Obj other

if (.AsUnit().IsValid) {
	Building it;

	it = other.AsBuilding();

	if (it.IsValid)
		if (it.IsCentralBuliding())
			if (!.IsEnemy(it)) {
				if (it.settlement.max_population > 0)
					return true;
				if (it.settlement.max_units > 0)
					if (!it.IsHeirOf("BaseRuins"))
						if (!it.IsHeirOf("Catapult"))
							return true;
			}
}

return false;