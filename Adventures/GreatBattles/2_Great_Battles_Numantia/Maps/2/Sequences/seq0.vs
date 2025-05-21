IntArray set_numbers;
str siege_group_name;
bool all_to_iberia;
int i, n, attack_interval, timer;

//villages around FoodStorage (NO_27) are ignored because sequence Event4 already manages them
set_numbers[0] = 39;//Numantia IOutpost N
set_numbers[1] = 36;//GuardTower
set_numbers[2] = 38;//Numantia IOutpost S
set_numbers[3] = 37;//Numantia village
set_numbers[4] = 23;//WatchTower GOutpost E
set_numbers[5] = 24;//WatchTower IOutpost SE
set_numbers[6] = 25;//WatchTower
set_numbers[7] = 28;//FoodStorage GOutpost NE
set_numbers[8] = 27;//FoodStorage
set_numbers[9] = 30;//FoodStorage COutpost NW
set_numbers[10] = 26;//FoodStorage IOutpost SE
set_numbers[11] = 33;//FoodStorage GOutpost SW
set_numbers[12] = 22;//WatchTower IOutpost E
set_numbers[13] = 21;//WatchTower ROutpost E
set_numbers[14] = 20;//SmallTown IOutpost E
set_numbers[15] = 19;//SmallTown COutpost E
set_numbers[16] = 18;//SmallTown ROutpost NE
set_numbers[17] = 16;//SmallTown
set_numbers[18] = 17;//SmallTown village
i = 19;
for (n = 15; n >= 1; n -= 1) {
	set_numbers[i] = n;//everything going from SmallTown IOutpost NW to starting point
	i += 1;
}

attack_interval = 360000 - GetDifficulty() * 30000;
timer = attack_interval;

while (NO_40.obj.player == 4) {
	Sleep(10000);
	timer -= 10000;
	if (timer <= 0) {
		timer = attack_interval;
		SpawnGroup("I_InnerWave1");
	}
	all_to_iberia = true;
	for (i = 0; i < 34; i += 1) {
		n = set_numbers[i];
		siege_group_name = "I_InnerWave1_S_" + n;
		if (GetNamedObj("NO_" + n).obj.player == 1) {
			all_to_iberia = false;
			if (!I_InnerWave1.IsEmpty()) {
				I_InnerWave1.AddToGroup(siege_group_name);
				I_InnerWave1.RemoveFromGroup("I_InnerWave1");
				if (!IsAIHelperRunning("AI_" + siege_group_name))
					RunAIHelper("AI_" + siege_group_name, "siege", siege_group_name, "S_" + n);
			}
		}
		else {
			StopAIHelper("AI_" + siege_group_name);
			if (!Group(siege_group_name).IsEmpty()) {
				Group(siege_group_name).AddToGroup("I_InnerWave1");
				Group(siege_group_name).RemoveFromGroup(siege_group_name);
			}
		}
	}
	if (all_to_iberia)
		I_InnerWave1.SetCommand("advance", R_Scipio.obj.pos);
}