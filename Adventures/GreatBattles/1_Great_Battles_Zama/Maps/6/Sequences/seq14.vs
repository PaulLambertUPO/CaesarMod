while (EnvReadInt("/En_AllowForbiddenArea") != 1) {
	if (!Subtract(ClassPlayerAreaObjs(cMilitary, 1, "A_Forbidden"), Q_Scipio).IsEmpty())
		Subtract(ClassPlayerAreaObjs(cMilitary, 1, "A_Forbidden"), Q_Scipio).SetCommand("move", GetRandomPointInArea("A_ScipioDest1"));
	Sleep(2000);
}