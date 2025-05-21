Settlement set2, set3, set4, set5, set6, set7;
int difficulty;

difficulty = GetDifficulty();

{
	Building b;

	b = NO_Town2.obj.AsBuilding();
	b.Research("Gaul Horseman");
	b.Research("Gaul Exceptional Horseshoes");
	b.Research("Warrior Tales");

	b = NO_Town3.obj.AsBuilding();
	b.Research("Gaul Axeman");
	b.Research("Gaul Iron Axes");
	b.Research("Gaul Training 1");
	b.Research("Gaul Training 2");
	b.Research("Gaul Training 3");

	b = NO_Town4.obj.AsBuilding();
	b.Research("Gaul Woman Warrior");
	b.Research("Gaul Fine Armor");
	b.Research("Battle tactics");

	b = NO_Town5.obj.AsBuilding();
	b.Research("Tournaments");
	b.Research("Code of Valor");
	b.Research("Free Drinks");

	b = NO_Town6.obj.AsBuilding();
	b.Research("TFights");
	b.Research("German chamber");
	b.Research("TGrainTrade");
}

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");
set4 = GetSettlement("S_Town4");
set5 = GetSettlement("S_Town5");
set6 = GetSettlement("S_Town6");
set7 = GetSettlement("S_Town7");

if (difficulty == 0) {
	set2.SetFood(3000);
	set2.SetGold(6000);
	set2.SetPopulation(50);
	set3.SetFood(3000);
	set3.SetGold(6000);
	set3.SetPopulation(50);
	set4.SetFood(3000);
	set4.SetGold(6000);
	set4.SetPopulation(50);
	set5.SetFood(3000);
	set5.SetGold(6000);
	set5.SetPopulation(50);
	set6.SetFood(3000);
	set6.SetGold(6000);
	set6.SetPopulation(50);
}
else if (difficulty == 1) {
	set2.SetFood(4000);
	set2.SetGold(7000);
	set2.SetPopulation(65);
	set3.SetFood(4000);
	set3.SetGold(7000);
	set3.SetPopulation(65);
	set4.SetFood(4000);
	set4.SetGold(7000);
	set4.SetPopulation(65);
	set5.SetFood(4000);
	set5.SetGold(7000);
	set5.SetPopulation(65);
	set6.SetFood(4000);
	set6.SetGold(7000);
	set6.SetPopulation(65);
	EnvWriteString(set2, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set7, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set7, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set7, "StartingBonusP4", "BonusGold20");
	EnvWriteString(set7, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set7, "StartingBonusP8", "BonusGold20");
}
else {
	set2.SetFood(5000);
	set2.SetGold(8000);
	set2.SetPopulation(80);
	set3.SetFood(5000);
	set3.SetGold(8000);
	set3.SetPopulation(80);
	set4.SetFood(5000);
	set4.SetGold(8000);
	set4.SetPopulation(80);
	set5.SetFood(5000);
	set5.SetGold(8000);
	set5.SetPopulation(80);
	set6.SetFood(5000);
	set6.SetGold(8000);
	set6.SetPopulation(80);
	EnvWriteString(set2, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set7, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set7, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set7, "StartingBonusP4", "BonusGold50");
	EnvWriteString(set7, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set7, "StartingBonusP8", "BonusGold50");
}

AIStart(2, "DEFAULT", 2);
AIStart(3, "DEFAULT", 2);
AIStart(4, "DEFAULT", 2);
AIStart(7, "DEFAULT", 2);
AIStart(8, "DEFAULT", 2);

while (1) {
	if (difficulty == 1) {
		if (set2.player != 1)
			set2.SetGold(set2.gold + 20);
		if (set3.player != 1)
			set3.SetGold(set3.gold + 20);
		if (set4.player != 1)
			set4.SetGold(set4.gold + 20);
		if (set5.player != 1)
			set5.SetGold(set5.gold + 20);
		if (set6.player != 1)
			set6.SetGold(set6.gold + 20);
		if (set7.player != 1)
			if (!set7.IsIndependent())
				set7.SetGold(set7.gold + 20);
	}
	else if (difficulty == 2) {
		if (set2.player != 1)
			set2.SetGold(set2.gold + 50);
		if (set3.player != 1)
			set3.SetGold(set3.gold + 50);
		if (set4.player != 1)
			set4.SetGold(set4.gold + 50);
		if (set5.player != 1)
			set5.SetGold(set5.gold + 50);
		if (set6.player != 1)
			set6.SetGold(set6.gold + 50);
		if (set7.player != 1)
			if (!set7.IsIndependent())
				set7.SetGold(set7.gold + 50);
	}
	Sleep(2000);
}