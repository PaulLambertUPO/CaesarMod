Settlement set2, set3;
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
	b.Research("Greek Royal Armor");
	b.Research("Greek Chariot Wheels");
	b.Research("Strengthen Stronghold Gates");

	b = NO_Town3.obj.AsBuilding();
	b.Research("Greek Horse Armor");
	b.Research("Greek Chariot Wheels");
	b.Research("Strengthen Stronghold Gates");

	EnvWriteString(2, "GovernmentForm", "Oligarchy");
	EnvWriteString(3, "GovernmentForm", "Democracy");
}

set2 = GetSettlement("S_Town2");
set3 = GetSettlement("S_Town3");

if (difficulty == 0) {
	set2.SetFood(3000);
	set2.SetGold(6000);
	set2.SetPopulation(50);
	set3.SetFood(3000);
	set3.SetGold(6000);
	set3.SetPopulation(50);
}
else if (difficulty == 1) {
	set2.SetFood(4000);
	set2.SetGold(7000);
	set2.SetPopulation(65);
	set3.SetFood(4000);
	set3.SetGold(7000);
	set3.SetPopulation(65);
	EnvWriteString(set2, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold20");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold20");
}
else {
	set2.SetFood(5000);
	set2.SetGold(8000);
	set2.SetPopulation(80);
	set3.SetFood(5000);
	set3.SetGold(8000);
	set3.SetPopulation(80);
	EnvWriteString(set2, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set2, "StartingBonusP3", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP2", "BonusGold50");
	EnvWriteString(set3, "StartingBonusP3", "BonusGold50");
}

AIStart(2, "DEFAULT", 2);
AIStart(3, "DEFAULT", 2);

while (1) {
	if (difficulty == 1) {
		if (set2.player != 1)
			set2.SetGold(set2.gold + 20);
		if (set3.player != 1)
			set3.SetGold(set3.gold + 20);
	}
	else if (difficulty == 2) {
		if (set2.player != 1)
			set2.SetGold(set2.gold + 50);
		if (set3.player != 1)
			set3.SetGold(set3.gold + 50);
	}
	Sleep(2000);
}