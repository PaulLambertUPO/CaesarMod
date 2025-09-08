//bool, Obj me, point pt

Catapult this;

this = me.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (.InRange(pt))
				return true;

return false;