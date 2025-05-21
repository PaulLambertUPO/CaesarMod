//void, int playerid

//this script shows a hint about equipping units

Sleep(240000);

if (Count(playerid, cMilitary) < 30) {
	ObjList ol;
	ol = ClassPlayerObjs(cBaseBarracks, playerid).GetObjList();
	if (ol.count > 0)
		ShowHint(
			Translate("Equip more units!"),
			Translate("You should train some more warriors in the barracks."),
			ol[0]
		);
}