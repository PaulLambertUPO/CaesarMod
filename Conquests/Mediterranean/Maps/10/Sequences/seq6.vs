Sleep(1000);

while (1) {
	if (NO_Town1.obj.player == 1)
		if (NO_Town2.obj.player == 1)
			if (I_Heroes.IsEmpty())
				break;
	Sleep(10000);
}

SetTerritoryState("Iberia", tsOwned);
Sleep(1000);
EndGame(1, false, Translate("You have conquered Iberia!"));