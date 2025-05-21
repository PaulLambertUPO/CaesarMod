// void, Obj This

Settlement this;
Ship       ship;
point      pt;
str        class;

this = This.AsBuilding.settlement;
class = cmdparam;

.GetCentralBuilding.Progress();
ship = .CreateShip(class);
if (ship.IsValid)
{
	pt = .GetCentralBuilding.GetExitVector();
	ship.ShowBuildAnimation( pt );
}
