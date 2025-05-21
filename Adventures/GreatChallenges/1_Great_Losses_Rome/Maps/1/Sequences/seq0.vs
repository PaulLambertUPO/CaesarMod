while (1) {
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_ChariotsCome1"), 1, 1000, 1000))
		break;
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_ChariotsCome2"), 1, 1000, 1000))
		break;
	Sleep(50);
}
SpawnGroup("Q_Retaliation2");
while (!Q_Retaliation2.IsEmpty()) {
	Q_Retaliation2.SetCommand("attack", Q_HannibalArmy.NearestObj(AreaCenter("A_ChariotsCome2")).posRH);
	Sleep(15000);
}