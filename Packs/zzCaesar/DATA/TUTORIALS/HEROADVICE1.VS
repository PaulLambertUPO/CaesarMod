//void, int playerid

//this script shows a hint about hiring heroes

Sleep(35000);

if (Count(playerid, cHero) < 1) {
	ObjList ol;
	ol = ClassPlayerObjs(cBaseArena, playerid).GetObjList();
	if (ol.count > 0)
		ShowTutorial(
			Translate("Hiring heroes"),
			Translate("Heroes are powerful leaders with special abilities that can command your armies. They are hired from the arena."),
			ol[0]
		);
}