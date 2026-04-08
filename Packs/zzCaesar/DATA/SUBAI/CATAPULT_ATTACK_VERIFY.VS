//bool, Obj This, Obj other

if (other.IsValid) {
	Catapult this;

	this = This.AsCatapult();

	if (.IsValid)
		if (.IsAlive)
			if (.IsBuilt)
				if (.IsEnemy(other))
					if (.IsValidTarget(other))
						if (.InRange(.GetPointOnTarget(other)))
							return true;
}

return false;