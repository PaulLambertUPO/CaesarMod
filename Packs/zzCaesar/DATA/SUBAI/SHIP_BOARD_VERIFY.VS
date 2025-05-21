//bool, Obj this, Obj other

Ship me;

me = .AsShip();

if (me.IsValid)
	if (me.UnitsCount < me.UnitsMax)
		if (!me.IsEnemy(other))
			if (!other.IsWaterUnit)
				if (!other.IsSentry)
					if (!other.IsRam)
						if (!other.AsBuilding().IsValid)
							return true;

return false;