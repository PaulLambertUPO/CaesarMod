//bool, Obj This, point pt

Catapult this;

this = This.AsCatapult();

if (.IsValid)
	if (.IsAlive)
		if (.IsBuilt)
			if (.InRange(pt))
				return true;

return false;