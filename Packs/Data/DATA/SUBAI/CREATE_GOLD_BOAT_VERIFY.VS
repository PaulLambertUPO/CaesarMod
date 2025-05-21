//bool, ObjList objs, str OUT reasonText

int nMinRes;

nMinRes = GetConst("MinResQtyToTransport");
if(objs.count)
{
	Building bld;
	bld = objs[0].AsBuilding();
	if(bld.IsValid)
	{
		Settlement this;
		this = bld.settlement;
		if(.IsValid)
		{
			if(.gold < nMinRes)
			{
				reasonText = rollover(bld,true) + "\n<color 255 0 0>";
				reasonText = reasonText + Translatef("Requires %s1 gold", nMinRes);
				return false;
			}
		}
	}
}
return true;