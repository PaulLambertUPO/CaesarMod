//void, Obj This

Building this;

this = This.AsBuilding();

.Progress();

{
	Ship ship;

	ship = .settlement.CreateShip(cmdparam);

	if (ship.IsValid) {
		point pt_exit;

		pt_exit = .GetExitVector();//the minimum areas of the Roman NW-NE shipyards do not have water in the destination, which causes ShowBuildAnimation to make the ship move on land only...

		if (.IsHeirOf("RShipyard2")) {//Roman NW
			if (!IsPointInWater(pt_exit + .pos + Point(-.radius, -.radius)))
				pt_exit.Set(pt_exit.x, -pt_exit.y);
		}
		else if (.IsHeirOf("RShipyard4")) {//Roman NE
			if (!IsPointInWater(pt_exit + .pos + Point(.radius, -.radius)))
				pt_exit.Set(pt_exit.x, -pt_exit.y);
		}

		if (ship.class == "ShipL")//only the original ship from Celtic Kings has the building animation
			ship.ShowBuildAnimation(pt_exit);
		else {
			pt_exit.Rot(rand(91) - 45);//randomly rotate the destination to reduce the risk of ships getting stuck in the shipyard (they can be moved manually, but it's not nice to look at)

			if (.IsHeirOf("GShipyard3"))//Gaul NE
				ship.SetCommand("move", .pos + pt_exit * 3);
			else if (.IsHeirOf("GShipyard4"))//Gaul NW
				ship.SetCommand("move", .pos + pt_exit * 3);
			else
				ship.SetCommand("move", .pos + pt_exit * 5);
		}
	}
}