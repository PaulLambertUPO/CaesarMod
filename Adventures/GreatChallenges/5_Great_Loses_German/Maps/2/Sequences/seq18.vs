int i;

while (NO_Village5.obj.player == 6) {
	Sleep(5000);
	NO_Village5.obj.Damage(5000);
	for (i = 1; i < 4; i += 1)
		GetNamedObj("NO_Damaged" + i).obj.Damage(5000);
}

_PlaceEx("WatchEye", 5349, 15237, 1);

Sleep(2000);

NO_Village5.obj.Heal(5000);
for (i = 1; i < 4; i += 1)
	GetNamedObj("NO_Damaged" + i).obj.Heal(5000);

GetSettlement("S_Village5").SetPopulation(30);