//bool, Obj This, Obj other

if (other.IsValid) {
	Catapult this;

	this = This.AsCatapult();

	if (.IsValid)
		if (.IsAlive)
			if (.IsBuilt)
				if (.IsEnemy(other))
					if (.IsValidTarget(other))
						if (.InRange(other.pos))
							return true;
}

return false;