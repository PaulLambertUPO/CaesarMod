//bool, Obj me, Obj other

Catapult this;

this = me.AsCatapult();

if (other.IsValid)
	if (.IsEnemy(other))
		if (.IsValidTarget(other))
			if (.InRange(other.pos))
				return true;

return false;