ObjList ol;
point p_view;

WaitEnvIntBetween("/En_AllowForbiddenArea", 1, 1, -1);

Sleep(5000);

BlockUserInput();
NO_Scipio.SetMessengerStatus(true);

HideZoomMap();
p_view = ViewPos();
View(AreaCenter("A_ViewShipyard"), true);
SetFog(false);
SpawnGroup("Q_Hannibal").SetCommand("attack", AreaCenter("A_ViewShipyard"));
NO_Hannibal.obj.AsHero().SetAutocast(true);
NO_Hannibal.AddCommand(false, "attack", AreaCenter("A_HannibalMoves1"));
NO_Hannibal.AddCommand(false, "attack", AreaCenter("A_HannibalMoves2"));
Sleep(500);
Q_HarborGuards.SetCommand("attach", NO_Hannibal);
Sleep(1000);
SpawnGroup("Q_HannibalLine1").SetCommandOffset("attack", AreaCenter("A_HannibalMoves1") - Point(200, 0));
Sleep(1000);
SpawnGroup("Q_HannibalLine2").SetCommandOffset("attack", AreaCenter("A_HannibalMoves1") - Point(500, 0));
Sleep(1000);
SpawnGroup("Q_HannibalLine3").SetCommandOffset("attack", AreaCenter("A_HannibalMoves1") - Point(700, 0));
Q_HannibalPersonalEscort.SetCommand("attach", NO_Hannibal);
Sleep(5000);
View(p_view, false);
SetFog(true);

NO_Scipio.SetMessengerStatus(false);
UnblockUserInput();

RunConv("HannibalArrives");
GiveNote("Zama");

if (!Q_Masinissa.IsEmpty()) {
	ClassPlayerObjs(cCNumidianRider, 2).SetCommand("attach", NO_Masinissa);
	NO_Masinissa.Heal(2000);
	NO_Masinissa.SetCommand("attack", AreaCenter("A_Masinissa"));
	if (!Q_SyphaxHeroes.IsEmpty()) {
		Q_SyphaxHeroes.SetCommand("leavearmy");
		Sleep(500);
		Q_SyphaxHeroes.SetCommand("move", AreaCenter("A_NumidiansLeave"));
	}
	Sleep(1000);
	SpawnGroup("Q_FinalCamels").SetCommand("attach", NO_Masinissa);
	ClassPlayerObjs(cCLibyanFootman, 2).SetCommand("attack", AreaCenter("A_Footmen"));
	ClassPlayerObjs(cCBerberAssassin, 2).SetCommand("attack", AreaCenter("A_Assassins"));
	Union(ClassPlayerObjs(cCJavelinThrower, 2), ClassPlayerObjs(cCHorseman, 2)).SetCommand("attack", AreaCenter("A_Masinissa"));
}
else
	ClassPlayerObjs(cMilitary, 2).AddToGroup("Q_NumidiansLeave");

if (EnvReadInt("/En_UticaTaken") != 1)
	if (!IsNoteActive("City of Utica"))
		GiveNote("City of Utica");

WaitUnitsInArea(Q_Scipio, "A_Battlefield", -1);

BlockUserInput();
HideZoomMap();
SetFog(false);
StartViewFollow(NO_Scipio);
Q_Scipio.SetCommand("move", AreaCenter("A_ScipioDest1"));
Q_Scipio.AddCommand(false, "move", AreaCenter("A_ScipioDest2"));
WaitUnitsInArea(Q_Scipio, "A_ScipioDest2", -1);
WaitUnitsInArea(Q_Hannibal, "A_HannibalMoves2", -1);
StopViewFollow();
UnblockUserInput();

Sleep(5000);
Q_HannibalFullArmy.SetCommand("attack", AreaCenter("A_Battle"));
ol = Subtract(ClassPlayerObjs(cMilitary, 2), Q_NumidiansLeave).GetObjList();
ol.ClearDead();
if (ol.count > 0)
	ol.SetCommand("attack", AreaCenter("A_Battle"));
Sleep(30000);

while (!Q_HannibalFullArmy.IsEmpty()) {
	ol.ClearDead();
	if (ol.count > 0) {
		if (ol[0].IsValid)
			Q_HannibalFullArmy.SetCommand("attack", ol[0].posRH);
	}
	else
		break;
	Sleep(30000);
}

while (!Q_HannibalFullArmy.IsEmpty()) {
	if (!Q_HannibalCore.IsEmpty())
		Q_HannibalCore.SetCommand("attack", NO_Scipio.obj.posRH);
	if (!Q_HannibalArmy.IsEmpty())
		if (NO_Utica.obj.player == 1) {
			if (!IsAIHelperRunning("UticaSiege"))
				RunAIHelper("UticaSiege", "siege", "Q_HannibalArmy", "S_Utica");
		}
		else {
			StopAIHelper("UticaSiege");
			Q_HannibalArmy.SetCommand("attack", NO_Scipio.obj.posRH);
		}
	Sleep(10000);
}

EnvWriteInt("/En_HannibalDefeated", 1);