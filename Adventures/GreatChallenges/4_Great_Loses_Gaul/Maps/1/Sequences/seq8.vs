int i;

WaitEmptyQuery(R_Intro, -1);

while (EnvReadInt("/En_End") != 1) {
	for (i = 1; i <= 8; i += 1)
		if (Group("G_Chieftains" + i).IsEmpty())
			if (!Group("G_CorridorDefenders" + i).IsEmpty())
				Group("G_CorridorDefenders" + i).RemoveFromGroup("G_CorridorDefenders");
	Sleep(5000);
}