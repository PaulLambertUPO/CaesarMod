Settlement set;

set = GetSettlement("AI_Settlement");

EnvWriteString(set, "StartingBonusP8", "BonusGold50");

set.GetCentralBuilding().Research("Strengthen Stronghold Defences I");
set.GetCentralBuilding().Research("Strengthen Stronghold Defences II");
set.GetCentralBuilding().Research("Battle tactics");

while (set.player == 8) {
	if (set.gold < 20000)
		set.SetGold(set.gold + 100);
	if (set.food < 20000)
		set.SetFood(set.food + 200);
	if (set.population < 165)
		set.AddToPopulation(5);
	Sleep(2000);
}