int initial_chieftains, dead_chieftains;

initial_chieftains = G_Chieftains.count;

WaitEmptyQuery(R_Intro, -1);

while (EnvReadInt("/En_FinalWave") != 1) {
	dead_chieftains = initial_chieftains - G_Chieftains.count;
	if (dead_chieftains >= 1)
		ShowAnnouncement("Leaders", Translatef("Dead chieftains: %s1", dead_chieftains));
	Sleep(5000);
}

if (G_Chieftains.count <= 4) {
	ShowAnnouncement("Leaders", Translate("The passes have been seized"));
	Sleep(20000);
}
HideAnnouncement("Leaders");