Settlement set;
int difficulty;

difficulty = GetDifficulty();

{
	Building b;

	b = NO_Town2.obj.AsBuilding();
	b.Research("Code of Valor");
	b.Research("Ancestral Knowledge");
	b.Research("Cover of Mercy");
	b.Research("IRestoration");
	b.Research("Heroes' Wisdom");
	b.Research("Warriors' Wisdom");
	b.Research("Nobility");
	b.Research("Housing");
	b.Research("More Housing");
}

set = GetSettlement("S_Town2");

if (difficulty == 0) {
	set.SetFood(3000);
	set.SetGold(6000);
	set.SetPopulation(50);
}
else if (difficulty == 1) {
	set.SetFood(4000);
	set.SetGold(7000);
	set.SetPopulation(65);
	EnvWriteString(set, "StartingBonusP2", "BonusGold20");
}
else {
	set.SetFood(5000);
	set.SetGold(8000);
	set.SetPopulation(80);
	EnvWriteString(set, "StartingBonusP2", "BonusGold50");
}

AIStart(2, "DEFAULT", 2);

while (1) {
	if (set.player != 1)
		if (difficulty == 1)
			set.SetGold(set.gold + 20);
		else if (difficulty == 2)
			set.SetGold(set.gold + 50);
	Sleep(2000);
}