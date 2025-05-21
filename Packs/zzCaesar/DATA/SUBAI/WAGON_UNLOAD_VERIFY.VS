//bool, Obj this, Obj other

Wagon me;

me = .AsWagon();

if (me.IsValid) {
	Building it;

	it = other.AsBuilding();

	if (it.IsValid)
		if (it.IsCentralBuliding)
			if (!me.IsEnemy(it))
				if (me.restype == 1) {//0 = gold, 1 = food
					if (it.settlement.max_food > 0)
						return true;
				}
				else if (it.settlement.max_gold > 0)//note that tents have 0 so it is not needed to use IsHeirOf/IsTTent
					return true;
}

return false;