//bool, Obj This, point pt

if (!IsPointInWater(pt))
	if (This.AsShip().UnitsCount > 0)
		return true;

return false;