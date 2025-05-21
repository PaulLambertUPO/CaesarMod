//void, int playerid

//this script shows a hint about ships and boats

ObjList player_shipyards;

Sleep(300000);

while (1) {
	Sleep(60000);
	if (!Union(ClassPlayerObjs(cShipL, playerid), ClassPlayerObjs(cShipS, playerid)).IsEmpty())
		return;
	player_shipyards = ClassPlayerObjs(cBaseShipyard, playerid).GetObjList();
	if (player_shipyards.count > 0) {
		ShowHint(
			Translate("Building ships"),
			Translate("Use your shipyards to build ships that can transport resources and units. There are two types of vessels: boats and ships. Boats are used solely for transporting resources and work like land caravans. Ships are used for naval combat and to transport up to 120 units over water. The higher the amount of units aboard is, the higher the attack speed and repairs will be."),
			player_shipyards[rand(player_shipyards.count)]
		);
		return;
	}
}