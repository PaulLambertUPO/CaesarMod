Settlement set;

set = GetSettlement("AI_Settlement");

Sleep(300000);

while (set.player == 8) {
	if (set.population < 165)
		set.AddToPopulation(5);
	if (set.food < 32000)
		set.SetFood(set.food + 600);
	if (set.gold < 32000)
		set.SetGold(set.gold + 110);
	Sleep(5200);
}