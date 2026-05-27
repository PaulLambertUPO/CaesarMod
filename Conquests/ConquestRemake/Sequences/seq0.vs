Settlement set;
int difficulty;

SetGlobalBloodlust(false);//bloodlust is bugged and its effect is kept active even in other games if the current one is quit before the ritual ends

difficulty = GetDifficulty();

set = GetSettlement("S_Town1");

if (difficulty == 0) {
	set.SetFood(5000);
	set.SetGold(14000);
	set.SetPopulation(80);
}
else if (difficulty == 1) {
	set.SetFood(4000);
	set.SetGold(12000);
	set.SetPopulation(65);
}
else {
	set.SetFood(3000);
	set.SetGold(10000);
	set.SetPopulation(50);
}

GetSettlement("S_Village").StartSupplyFood(set);

RunSequence(ConquestBonus());