// void, Obj This,Obj bld

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

//Horse can enter only in iberian villages.
if(building.IsHeirOf("IVillage") == false) 
{
	return;
}

set = building.settlement();
if(set.IsValid() == false)
{
	return;
}

.SetSpeedFactor(150);
.SetWalkAnim(2);

.SetEntering(true);																
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
	EnvWriteInt(set, "EEE_IVillageNumberHorses", EnvReadInt(set, "EEE_IVillageNumberHorses") + 1);
	.Erase();
}
