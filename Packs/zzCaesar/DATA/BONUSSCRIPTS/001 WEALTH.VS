//void, Settlement set, int playerid

Sleep(100);

EnvWriteString(set, "StartingBonusP" + playerid, "BonusGold20");//for AI scripts and Conquest sequences

set.SetGold(set.gold + 2000);
set.GoldConverted(2000);

while (1) {
	Sleep(2000);
	if (set.IsValid)
		if (set.player == playerid) {
			set.SetGold(set.gold + 20);
			set.GoldConverted(20);
		}
}