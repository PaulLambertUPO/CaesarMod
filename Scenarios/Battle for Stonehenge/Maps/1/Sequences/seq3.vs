Sleep(600000);
while (BlackOulderum.obj.player == 8) {
	if (T_NorthEast.count < 20)
		SpawnGroupInHolder("T_NorthEast", "AI_Settlement");
	if (T_NorthWest.count < 20)
		SpawnGroupInHolder("T_NorthWest", "AI_Settlement");
	Sleep(600000);
}