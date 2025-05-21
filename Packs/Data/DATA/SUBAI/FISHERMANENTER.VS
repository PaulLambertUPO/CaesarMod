// void, Obj This, Obj bld

Unit this;
point pt, ptDummy;
Building building;
Settlement set;
Obj objDummy;

this = This.AsUnit();
building = bld.AsBuilding();

if(.IsValid() == false || .IsAlive() == false)
	return;

if(building.IsValid() == false || this.IsEnemy(building) == true)
	return;

//Fisherman can enter only in shipyard.
if(building.IsHeirOf("BaseShipyard") == false) 
{
	return;
}

.SetEntering(true);

set = building.settlement();
if(set.IsValid() == false)
{
 
	return;
}

if(set.Units().Contains(this) == false)

{

	pt = building.GetEnterPoint(this);

	while(!.GotoEnter(pt, 0, 1000, true, 5000))
	{
		if(this.IsEnemy(building) == true)
		{
			return;
		}
		Sleep(100);
	}

	.ExecCmd("detach",ptDummy,objDummy,false);
	EnvWriteInt(set, "Fishermen", EnvReadInt(set, "Fishermen") + 1);
	.Erase();

}