//bool, ObjList objs, str OUT reasonText

Building this;
int min_resource;

this = objs[0].AsBuilding();

min_resource = GetConst("MinResQtyToTransport");

if (.settlement.gold >= min_resource)
	return true;

reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translatef("Requires %s1 gold", min_resource);

return false;