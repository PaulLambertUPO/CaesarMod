//bool, ObjList objs, str OUT reasonText

Building this;
str production;

if(objs.count > 0)
{
	this = objs[0].AsBuilding();
	if(.IsValid())
	{
        production = EnvReadString(.settlement, "ENV_TProd");
        
        if(production == "TTeutonRider"){
            return true;
        }
	}
}
return false;
