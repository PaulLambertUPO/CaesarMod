Sleep(6000);
while (1) {
	Sleep(1500);
	ShowAnnouncement("Sacrif", Translatef("Peasants for the ritual: %s1/50", ClassPlayerAreaObjs(cPeasant, 3, "A_Sacrifice").count));
}