int i;

while (1) {
	for (i = 1; i <= 4; i += 1)
		if (GetNamedObj("Village" + i).obj.player == 1)
			if (!ClassPlayerAreaObjs("EPriest", 1, "A_Altar" + i).IsEmpty()) {
				SpawnGroup("Slave" + i).SetCommand("enter", Town);
				SpawnGroup("Camel" + i).SetCommand("unload", Town);
				Sleep(5000);
			}
}