while (EnvReadInt("/En_AllowForbiddenArea") != 1) {
	if (!Intersect(ClassPlayerAreaObjs(cMilitary, 1, "A_Forbidden"), Q_Scipio).IsEmpty()) {
		RunConv("ForbiddenAreaSpeech");
		BlockUserInput();
		NO_Scipio.SetMessengerStatus(true);
		while (Intersect(ClassPlayerAreaObjs(cMilitary, 1, "A_ScipioDest1"), Q_Scipio).IsEmpty()) {
			NO_Scipio.SetCommand("move", AreaCenter("A_ScipioDest1"));
			Sleep(1000);
		}
		NO_Scipio.SetMessengerStatus(false);
		UnblockUserInput();
	}
	Sleep(2000);
}