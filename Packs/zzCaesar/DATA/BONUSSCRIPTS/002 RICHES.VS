//void, Settlement set, int playerid

Sleep(100);

EnvWriteString(set, "StartingBonusP" + playerid, "BonusGold50");//for AI scripts and Conquest sequences

set.SetGold(set.gold + 5000);
set.GoldConverted(5000);

while (1) {
	Sleep(2000);
	if (set.IsValid)
		if (set.player == playerid) {
			set.SetGold(set.gold + 50);
			set.GoldConverted(50);
		}
}