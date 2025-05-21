//bool, Obj this, Obj other

if (!.IsWaterUnit)
	if (!.IsEnemy(other))
		if (!other.IsEnemy(this))
			if (.AsUnit().IsValid)
				if (!.AsUnit().InShip)
					if (other.AsShip().IsValid)
						if (other.AsShip().UnitsCount < other.AsShip().UnitsMax)
							return true;

return false;