//bool, Obj This, Obj target

if (target.IsValid) {
	Hero this;

	this = This.AsHero();

	if (.IsValid)
		if (.IsAlive)
			if (target != this) {
				if (.IsEnemy(target))
					if (.IsValidTarget(target))
						return true;
				{
					ObjList h_army;
					Obj o;
					int i;

					h_army = .army;
					for (i = h_army.count - 1; i >= 0; i -= 1) {
						o = h_army[i];
						if (o.IsAlive)
							if (target != o)
								if (o.IsEnemy(target))
									if (o.IsValidTarget(target))
										return true;
					}
				}
			}
}

return false;