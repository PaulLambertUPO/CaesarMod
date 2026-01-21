//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

Building this;
Wagon boat;

this = objs[0].AsBuilding();

boat = .settlement.CreateBoatGold(250).AsWagon();

if (boat.IsValid) {
	point pt_exit;

	ClearSelection(player);
	boat.Select(player);

	pt_exit = .GetExitVector();
	pt_exit.Rot(rand(91) - 45);//randomly rotate the destination to reduce the risk of boats getting stuck in the shipyard (they can be moved manually, but it's not nice to look at)

	if (.IsHeirOf("GShipyard3"))//Gaul NE
		boat.SetCommand("move", .pos + pt_exit * 2);
	else if (.IsHeirOf("GShipyard4"))//Gaul NW
		boat.SetCommand("move", .pos + pt_exit * 2);
	else
		boat.SetCommand("move", .pos + pt_exit * 4);
}