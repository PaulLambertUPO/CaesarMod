//bool, Obj This, Obj other

Ship this;

this = This.AsShip();

if (.IsValid)
	if (.IsAlive)
		if (.UnitsCount < .UnitsMax)
			if (other != this)
				if (other.AsUnit().IsValid)
					if (other.IsAlive)
						if (!.IsEnemy(other))
							if (!other.AsFlying().IsValid)//flying units cause a crash
								if (!other.IsWaterUnit)
									if (!other.IsSentry)
										if (!other.IsPeasantAmbient)
											if (!other.IsRam)
												return true;

return false;