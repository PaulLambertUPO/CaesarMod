//void, int playerid

//this script shows a hint about caravans and their production

Sleep(5000);

if (WaitQueryCountBetween(ClassPlayerObjs(cWagon, playerid), 1, 1000, 35000))
	ShowHint(
		Translate("Caravans"),
		Translate("Caravans are used to transport resources from one settlement to another and also to provide other units with food to prevent them from starving. Note that caravans can be captured, so you should protect them."),
		GetPlayerUnits(playerid, cWagon)[0]
	);
else {
	Obj obj;
	ShowHint(
		Translate("Caravan production"),
		Translate("Caravans can be produced either automatically with supply routes or manually with specific commands in townhalls, villages, outposts and shipyards, but in all cases the minimum amount of resources required is 100. Caravans are used to transport resources from one settlement to another and also to provide other units with food to prevent them from starving. Note that caravans can be captured, so you should protect them."),
		obj
	);
}