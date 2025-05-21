Settlement set;
int bonus_food, bonus_gold;

set = GetSettlement("S_Alexandria");

bonus_food = 20 + GetDifficulty() * 15;
bonus_gold = 5 + GetDifficulty() * 10;

while (1) {
	Sleep(2000);
	if (set.player == 4) {
		set.SetGold(set.gold + bonus_gold);
		set.SetFood(set.food + bonus_food);
	}
}