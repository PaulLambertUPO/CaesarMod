WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_DetectAmbush1"), 1, 1000, -1);
SpawnGroup("Q_Retaliation1");
while (!Q_Retaliation1.IsEmpty()) {
	Q_Retaliation1.SetCommand("attack", Q_HannibalArmy.NearestObj(AreaCenter("A_DetectAmbush1")).posRH);
	Sleep(15000);
}