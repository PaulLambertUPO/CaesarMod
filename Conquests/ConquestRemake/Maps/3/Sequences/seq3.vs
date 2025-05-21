Settlement set2, set3, set4, set5, set6;
int difficulty;

difficulty = GetDifficulty();

{
	Building b;

	b = NO_Town2.obj.AsBuilding();
	b.Research("Path of the dead I");
	b.Research("Path of the dead II");
	b.Research("Path of the dead III");
	b.Research("Statue of Isis, mother of Anubis");
	b.Research("Mumification");

	b = NO_Town3.obj.AsBuilding();
	b.Research("Light of Horus I");
	b.Research("Light of Horus II");
	b.Research("Light of Horus III");
	b.Research("Statue of Osiris, father of Horus");
	b.Research("Mumification");

	//keep this research order to make sure population is optimized
	b = NO_Town4.obj.AsBuilding();
	b.Research("People's Assembly");
	b.Research("Dark Rituals");
	b.Research("Free Trade");

	b = NO_Town5.obj.AsBuilding();
	b.Research("Path of the dead I");
	b.Research("Path of the dead II");
	b.Research("Path of the dead III");
	b.Research("Light of Horus I");
	b.Research("Light of Horus II");
	b.Research("Light of Horus III");
	b.Research("Statue of Amon-Ra");
	b.Research("Mumification");
}

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");
set4 = GetSettlement("S_Town4");
set5 = GetSettlement("S_Town5");
set6 = GetSettlement("S_Town6");

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
	EnvWriteString(set2, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set4, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set5, "StartingBonusP8", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP7", "BonusGold20");
	EnvWriteString(set6, "StartingBonusP8", "BonusGold20");
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
	EnvWriteString(set2, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set4, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set5, "StartingBonusP8", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP7", "BonusGold50");
	EnvWriteString(set6, "StartingBonusP8", "BonusGold50");
}

AIStart(2, "DEFAULT", 2);
AIStart(3, "DEFAULT", 2);
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
			if (!set6.IsIndependent())
				set6.SetGold(set6.gold + 20);
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
			if (!set6.IsIndependent())
				set6.SetGold(set6.gold + 50);
	}
	Sleep(2000);
}