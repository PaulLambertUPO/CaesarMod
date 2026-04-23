//bool, Obj This, Obj other

Unit this;

this = This.AsUnit();

if (.IsValid)
	if (.IsAlive)
		if (!.HasFreedom) {
			Hero h;

			h = other.AsHero();

			if (h.IsValid)
				if (h.IsAlive)
					if (h != .hero)
						if (!h.IsHeroArmyFull)
							if (!.IsEnemy(h))
								if (!h.IsEnemy(this))
									return true;
		}

return false;