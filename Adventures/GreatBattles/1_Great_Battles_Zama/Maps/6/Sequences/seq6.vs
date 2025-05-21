point p_view;
int i, difficulty;

difficulty = GetDifficulty();

WaitEnvIntBetween("/En_IberiansArrived", 1, 1, -1);

Sleep(120000 - difficulty * 15000);
SpawnNamed("NO_IberianShip").SetCommand("move", AreaCenter("A_IberiansLand"));
WaitIdle(NO_IberianShip, -1);

BlockUserInput();
NO_Scipio.SetMessengerStatus(true);

HideZoomMap();
p_view = ViewPos();
View(NO_IberianShip.obj.pos, true);
Sleep(2500);
for (i = 1; i <= 3; i += 1) {
	SpawnGroup("Q_Iberians" + i);
	Sleep(1000);
	AttackArea(Group("Q_Iberians" + i), "A_IberiansStep1");
	Sleep(1000);
}
View(p_view, false);
RemoveNote("Landing site");
GiveNote("Iberian reinforcements");

NO_Scipio.SetMessengerStatus(false);
UnblockUserInput();

i = 1;
while (1) {
	if (Q_Iberians.IsEmpty()) {
		RunConv("IberiansDestroyed");
		EnvWriteInt("/En_IberiansDied", 1);
		GiveNote("Return to Masinissa");
		if (EnvReadInt("/En_UticaTaken") != 1)
			GiveNote("City of Utica");
		break;
	}
	if (WaitIdle(Q_Iberians, 10000)) {
		if (i >= 5) {
			EnvWriteInt("/En_SyphaxAssault", 2);
			Sleep(80000);
			break;
		}
		if (!Group("Q_Interceptors" + i).IsEmpty())
			Group("Q_Interceptors" + i).AddToGroup("Q_Iberians");
		Sleep(30000 - difficulty * 10000);
		i += 1;
		AttackArea(Q_Iberians, "A_IberiansStep" + i);
	}
}
RemoveNote("Iberian reinforcements");
while (!Q_Iberians.IsEmpty()) {
	Sleep(15000);
	Q_Iberians.SetCommand("attack", NO_Scipio.obj.posRH);
}