//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive)
		if (!.IsWaterUnit)
			if (!.AsUnit().InShip)
				if (other.AsShip().IsValid)
					if (!.IsEnemy(other))
						if (!other.IsEnemy(this))
							if (other.AsShip().UnitsCount < other.AsShip().UnitsMax)
								return true;

return false;