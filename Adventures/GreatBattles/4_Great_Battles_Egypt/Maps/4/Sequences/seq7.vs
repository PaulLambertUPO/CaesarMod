int i, player_gold, enemy_gold;
Settlement set;

player_gold = 500 - GetDifficulty() * 100;
enemy_gold = 300 + GetDifficulty() * 100;

while (1) {
	Sleep(60000);
	for (i = 1; i <= 9; i += 1) {
		set = GetSettlement("S_O" + i);
		if (set.player == 1)
			set.SetGold(set.gold + player_gold);
		else
			set.SetGold(set.gold + enemy_gold);
	}
}