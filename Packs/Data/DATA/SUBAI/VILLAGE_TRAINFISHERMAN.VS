// void, Obj This

Building this;
Unit unit;
point ptDest, pt;
int lRadius, i, pop_group;
int  xfix, yfix;

lRadius = GetConst("VillageTrainPeasantRadius");
pop_group = GetConst("PopGroup");
this = This.AsBuilding();
.Progress();

xfix = 1;
yfix = 1;

	ptDest.Set(1,1);
	ptDest.SetLen(rand(lRadius - .settlement.GetCentralBuilding().radius) + .settlement.GetCentralBuilding().radius );
	ptDest.Rot(rand(360));
	ptDest = ptDest + .settlement.GetCentralBuilding().pos;

	pt = .GetExitPoint(ptDest, false);

	unit = Place("Fisherman", pt, .player).AsUnit();

if(unit.IsValid() == false)
{
	return;
}

if(unit.IsAlive() == true){

	if (.settlement().supplied().IsValid() == true){

		if( (.settlement().supplied().IsTTent() == false) && (unit.IsEnemy(.settlement().supplied().GetCentralBuilding()) == false) ){

			unit.SetCommand("enter", .settlement().supplied().GetCentralBuilding());
			Sleep(250);
			return;

		}
	}

	unit.SetCommand("move", ptDest);
}