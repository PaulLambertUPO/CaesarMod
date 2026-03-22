//void, int player, str param

int i, elimination_timeout, time_to_survive, max_enemy_timer, enemy_timer;
bool enemies_losing;

SetGlobalBloodlust(false);//bloodlust is bugged and its effect is kept active even in other games if the current one is quit is stopped before the ritual ends

if (Strongholds(player) > 0) {
	ObjList player_villages;
	Settlement set;

	player_villages = GetSettlements("BaseVillage", player);

	for (i = 0; i < player_villages.count; i += 1) {
		set = player_villages[i].AsBuilding().settlement;
		if (!set.supplied.IsValid)
			set.StartSupplyFood(NearestStronghold(player_villages[i].pos, player));
	}
}

elimination_timeout = GetConst("EliminationTimeout");
time_to_survive = -1;

EnvWriteInt(player, "elimination", 0);

SetPlayerStatus(player, 0, Translate("Elimination"), false);

while (1) {
	//hide upper right corner messages
	SetPlayerStatus(player, 0, false);//game mode
	SetPlayerStatus(player, 1, false);//defeat timer
	SetPlayerStatus(player, 2, false);//victory timer

	if (time_to_survive == 0) {
		SetPlayerStatus(player, 0, true);
		SetPlayerStatus(player, 1, Translate("You were eliminated"), true);
		SetPlayerStatus(player, 2, true);
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true);
		return;
	}

	//check if all enemies will lose
	max_enemy_timer = 0;
	enemies_losing = true;
	for (i = 1; i <= 8; i += 1)
		if (i != player)
			if (!DiplAreAllied(i, player)) {
				enemy_timer = EnvReadInt(i, "elimination");
				if (enemy_timer > 0) {
					if (enemy_timer > max_enemy_timer)
						max_enemy_timer = enemy_timer;
				}
				else
					enemies_losing = false;
			}
	if (enemies_losing) {
		if (max_enemy_timer > 1) {
			SetPlayerStatus(player, 0, true);
			i = max_enemy_timer % 60;
			if (i < 10)
				SetPlayerStatus(player, 2, Translatef("You win after %s1:0%s2 minutes", max_enemy_timer / 60, i), true);
			else
				SetPlayerStatus(player, 2, Translatef("You win after %s1:%s2 minutes", max_enemy_timer / 60, i), true);
		}
	}
	else
		SetPlayerStatus(player, 2, "", false);

	if (Strongholds(player) <= 0) {//as long as at least 1 townhall is owned, timer before defeat does not start
		if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
			time_to_survive = 0;
			continue;
		}
		if (time_to_survive == -1)
			time_to_survive = elimination_timeout;
		SetPlayerStatus(player, 0, true);
		i = time_to_survive % 60;
		if (i < 10)
			SetPlayerStatus(player, 1, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, i), true);
		else
			SetPlayerStatus(player, 1, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, i), true);
		EnvWriteInt(player, "elimination", time_to_survive);
		time_to_survive -= 1;
	}
	else if (time_to_survive != -1) {//managed to recapture (or defeat timer has not started yet)
		SetPlayerStatus(player, 1, "", false);
		EnvWriteInt(player, "elimination", 0);
		time_to_survive = -1;
	}

	Sleep(1000);
}