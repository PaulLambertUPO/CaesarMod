//bool, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (.EnemiesInSight)
			if (.DistTo(pt) < 280)
				return true;

return false;