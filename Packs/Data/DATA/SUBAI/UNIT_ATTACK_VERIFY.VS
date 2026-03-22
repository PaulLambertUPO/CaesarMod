//bool, Obj This, Obj target

if (target.IsValid) {
	Unit this;

	this = This.AsUnit();

	if (.IsValid)
		if (.IsAlive)
			if (target != this)
				if (.IsEnemy(target))
					if (.IsValidTarget(target))
						return true;
}

return false;