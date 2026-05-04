//bool, ObjList objs, str OUT reasonText

int min_resource;

min_resource = GetConst("MinResQtyToTransport");

if (objs[0].AsBuilding().settlement.gold >= min_resource)
	return true;

reasonText = rollover() + "\n<color 255 0 0>" + Translatef("Requires %s1 gold", min_resource);

return false;