Settlement set37, set29;
int bonus_gold;

Sleep(30000);

AIStart(4, "DEFAULT", 2);
AIStart(5, "DEFAULT", 2);

SetAIVar(4, AIV_UseTeleports, 0);
SetAIVar(5, AIV_UseTeleports, 0);

set37 = GetSettlement("S_Sett37");
set29 = GetSettlement("S_Sett29");

bonus_gold = 10 + GetDifficulty() * 10;

while (1) {
	if (set37.player != 1)
		set37.SetGold(set37.gold + bonus_gold);
	if (set29.player != 1)
		set29.SetGold(set29.gold + bonus_gold);
	Sleep(2000);
}