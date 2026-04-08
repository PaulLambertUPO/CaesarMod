//bool, Obj this, Obj other

if (.AsUnit().IsValid)
	if (.IsAlive) {
		Building bld;

		bld = other.AsBuilding();

		if (bld.IsValid) {
			if (bld.AsTeleport().IsValid)
				return true;

			if (!bld.IsHeirOf("BaseRuins"))
				if (bld.IsCentralBuliding)
					if (!.IsEnemy(bld))
						if (bld.settlement.max_units > 0)
							if (DiplGetShareView(bld.player, .player))
								return true;
		}
	}

return false;