Sleep(100);
Q_IntroATTACH2.SetCommand("attach", NO_Hero2);
WaitQueryCountBetween(Q_Retreat2, 0, 43, -1);
RunConv("C_Conv1");
MoveToArea(Q_Retreat2, "A_Retreat2");
Sleep(10000);
NO_Hero2.SetCommand("stand_position");
Sleep(2000);
Q_IntroATTACH2.SetCommand("stand_position");
Q_Reinforcements1.AddToGroup("Q_Retreat2");
while (1) {
	if (WaitQueryCountBetween(Q_Retreat2, 0, 40, 500))
		break;
	if (WaitQueryCountBetween(ClassPlayerAreaObjs(cMilitary, 1, "A_Village1"), 1, 1000, 500))
		break;
	Sleep(50);
}
MoveToArea(Q_Retreat2, "A_Village1");
Q_Reinforcements2.AddToGroup("Q_Retreat2");
Sleep(15000);
RunAIHelper("VillageDef1", "guard area", "Q_Retreat2", "A_Village1");
WaitQueryCountBetween(Q_Retreat2, 0, 25, -1);
StopAIHelper("VillageDef1");
Q_Retreat2.SetCommand("enter", NO_OuterTown);