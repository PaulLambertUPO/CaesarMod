Sleep(1000);

while (1) {
	if (NO_Town1.obj.player != 1)
		if (NO_Town2.obj.player != 1)
			if (NO_Town3.obj.player != 1)
				if (NO_Town4.obj.player != 1)
					if (NO_Town5.obj.player != 1)
						if (NO_Town6.obj.player != 1)
							if (NO_Town7.obj.player != 1)
								break;
	Sleep(10000);
}

EndGame(1, true, Translate("You have failed to conquer Germany!"));