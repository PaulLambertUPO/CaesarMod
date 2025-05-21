Sleep(1000);

while (1) {
	if (NO_Town1.obj.player == 1)
		if (NO_Town2.obj.player == 1)
			if (NO_Town3.obj.player == 1)
				break;
	Sleep(10000);
}

SetTerritoryState("Greece", tsOwned);
Sleep(1000);
EndGame(1, false, Translate("You have conquered Greece!"));