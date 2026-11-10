Obj hall;

Sleep(600000);

hall = BlackOulderum;

while (hall.player == 8) {
	SpawnGroupInHolder("T_NorthEast", hall);
	SpawnGroupInHolder("T_NorthWest", hall);
	Sleep(600000);
}