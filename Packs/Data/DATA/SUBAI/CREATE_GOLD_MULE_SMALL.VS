//void, Obj This

Building this;
Wagon mule;

this = This.AsBuilding();

mule = .settlement.CreateMuleGold(250);

if (mule.IsValid) {
	point pt_exit;

	ClearSelection(mule.player);
	mule.Select(mule.player);

	if (.IsHeirOf("RomanShipyard")) {
		pt_exit = .GetExitVector();
		pt_exit.Rot(rand(91) - 45);//randomly rotate the destination to reduce the risk of boats getting stuck in the building (they can be moved manually, but it's not nice to look at)
		mule.SetCommand("move", .pos + pt_exit * -5);//go opposite the shipyard direction
	}
	else if (.IsHeirOf("GaulShipyard")) {
		pt_exit = .GetExitVector();
		pt_exit.Rot(rand(91) - 45);//randomly rotate the destination to reduce the risk of boats getting stuck in the building (they can be moved manually, but it's not nice to look at)
		mule.SetCommand("move", .pos + pt_exit * -2);//go opposite the shipyard direction
	}
	else {
		pt_exit = Point(.radius, .radius);
		pt_exit.Rot(rand(91) - 45);//randomly rotate the destination to reduce the risk of boats getting stuck in the building (they can be moved manually, but it's not nice to look at)
		mule.SetCommand("move", .pos + pt_exit);
	}
}