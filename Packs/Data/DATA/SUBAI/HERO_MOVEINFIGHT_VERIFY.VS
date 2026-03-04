//bool, Obj This, point pt

Hero this;

this = This.AsHero();

if (.IsValid)
	if (.IsAlive)
		if (.EnemiesInSight)
			if (pt.Dist(.posRH) < 300)
				return true;

return false;