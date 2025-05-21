while (1) {
	Sleep(150000);
	if (Q_CityGuard.count <= 5)
		SpawnGroupInHolder("Q_CityGuard", "S_Town");
}