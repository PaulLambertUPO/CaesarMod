//bool, Obj This, Obj other

Wagon this;

this = This.AsWagon();

if (.IsValid)
	if (.IsAlive)
		if (other != this)
			if (other.AsUnit().IsValid)
				if (other.IsAlive)
					if (!.IsEnemy(other))
						if (other.IsWaterUnit)
							if (.CanSee(other))
								return true;

return false;