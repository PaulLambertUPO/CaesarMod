Settlement set;
point pt;
int min_pop, i;

min_pop = GetConst("MinPopulation");

while (!set.IsValid) {
	if (NO_Alexandria.obj.player == 1)
		set = GetSettlement("S_Alexandria");
	else if (NO_Pelusio.obj.player == 1)
		set = GetSettlement("S_Pelusio");
	else if (NO_Memphis.obj.player == 1)
		set = GetSettlement("S_Memphis");
	for (i = 1; i <= 10; i += 1)
		GetSettlement("S_V" + i).SetPopulation(min_pop);
	Sleep(1500);
}

AIStart(4, "DEFAULT", 2);

RemoveNote("NavalBattleAdvice");
RemoveNote("PelusioAdvice");

SpawnGroupInHolder("R_FlaviusPublius", set.name);
pt = Point(0, 350);
pt.Rot(45);
R_FlaviusPublius.SetCommand("move", set.GetCentralBuilding().pos + pt);
R_FlaviusPublius.AddCommand(false, "hold_position");
Sleep(8000);

RunConv("HoldTowns");
GiveNote("LoseCondition2");
RunSequence("LoseTowns");

GiveNote("Outposts");
RunSequence("OutpostsGoldTrade");

RunSequence("AlexandriaWealth");
RunSequence("NavalAttacks");
RunSequence("CarthageAttacks");