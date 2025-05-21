Settlement set2, set3, set4, set5;
int difficulty;

difficulty = GetDifficulty();

{
	ObjList defenders;
	Unit u;
	int i;

	H_Defenders.SetCommand("stand_position");
	defenders = H_Defenders.GetObjList();
	for (i = 0; i < defenders.count; i += 1) {
		u = defenders[i].AsUnit();
		if (u.IsValid) {
			u.AddItem("Emblem of Democracy");
			u.AddItem("Emblem of Oligarchy");
			u.AddItem("Charm of Athena");
			u.AddItem("Charm of Aegle");
		}
	}
	H_Chariot.SetCommand("patrol", AreaCenter("A_Patrol"));
}

{
	Building b;

	b = NO_Town2.obj.AsBuilding();
	b.Research("Greek Spears");
	b.Research("Strengthen Stronghold Gates");
	b.Research("Charm of Athena");

	b = NO_Town3.obj.AsBuilding();
	b.Research("Greek Horse Armor");
	b.Research("Strengthen Stronghold Gates");
	b.Research("Charm of Aegle");

	b = NO_Town4.obj.AsBuilding();
	b.Research("Greek Royal Armor");
	b.Research("Strengthen Stronghold Gates");
	b.Research("Spartan Training");
	b.Research("Tribute to Heracles");

	b = NO_Town5.obj.AsBuilding();
	b.Research("Greek Chariot Wheels");
	b.Research("Strengthen Stronghold Gates");
	b.Research("Supplies");
	b.Research("Statue of Zeus");

	EnvWriteString(2, "GovernmentForm", "Democracy");
	EnvWriteString(3, "GovernmentForm", "Oligarchy");
	EnvWriteString(7, "GovernmentForm", "Oligarchy");
	EnvWriteString(8, "GovernmentForm", "Democracy");
}

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");
set4 = GetSettlement("S_Town4");
set5 = GetSettlement("S_Town5");

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
	}
	Sleep(2000);
}