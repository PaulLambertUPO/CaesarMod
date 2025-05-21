int i;
ObjList ol;

Sleep(10000);

while (1) {
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_NearingRome1"), 1, 1000, 1000))
		break;
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_NearingRome2"), 1, 1000, 1000))
		break;
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_NearingRome3"), 1, 1000, 1000))
		break;
	Sleep(50);
}

ol = Q_FrontGuard1.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_FrontGuard" + i));
	ol[i - 1].AddCommand(false, "stand_position");
}
ol = Q_FrontGuard2.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_FrontGuard" + i) - Point(50, 50));
	ol[i - 1].AddCommand(false, "stand_position");
}
ol = Q_FrontGuard3.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_RightFrontGuard" + i));
	ol[i - 1].AddCommand(false, "stand_position");
}
ol = Q_FrontGuard4.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_RightFrontGuard" + i) - Point(50, 0));
	ol[i - 1].AddCommand(false, "stand_position");
}
ol = Q_FrontGuard5.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_LeftFrontGuard" + i));
	ol[i - 1].AddCommand(false, "stand_position");
}
ol = Q_FrontGuard6.GetObjList();
for (i = 1; i <= ol.count; i += 1) {
	ol[i - 1].SetCommand("attack", AreaCenter("A_LeftFrontGuard" + i) - Point(0, 50));
	ol[i - 1].AddCommand(false, "stand_position");
}