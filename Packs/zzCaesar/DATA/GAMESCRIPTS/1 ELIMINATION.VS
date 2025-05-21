//void, int player, str param

Query owned_townhalls;
int i, time_to_survive, max_enemy_timeout, elimination_timeout;
bool enemies_losing;

owned_townhalls = ClassPlayerObjs("BaseTownhall", player);

if (!owned_townhalls.IsEmpty()) {
	ObjList player_villages;
	Settlement set;

	player_villages = ClassPlayerObjs("BaseVillage", player).GetObjList();

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
Sleep(10);

while (1) {
	//hide upper right corner messages
	SetPlayerStatus(player, 0, false);//game mode
	SetPlayerStatus(player, 1, false);//defeat timer
	SetPlayerStatus(player, 2, false);//victory timer

	if (time_to_survive == 0) {
		SetPlayerStatus(player, 0, true);
		SetPlayerStatus(player, 1, Translate("You were eliminated"), true);
		SetPlayerStatus(player, 2, false);
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true);
		return;
	}

	//check if all enemies will lose
	max_enemy_timeout = 0;
	enemies_losing = true;
	for (i = 1; i <= 8; i += 1)
		if (i != player)
			if (!DiplAreAllied(i, player)) {
				int enemy_timer;
				enemy_timer = EnvReadInt(i, "elimination");
				if (enemy_timer > 0) {
					if (enemy_timer > max_enemy_timeout)
						max_enemy_timeout = enemy_timer;
				}
				else
					enemies_losing = false;
			}
	if (enemies_losing)
		if (max_enemy_timeout > 1) {
			SetPlayerStatus(player, 0, true);
			if (max_enemy_timeout % 60 < 10)
				SetPlayerStatus(player, 2, Translatef("You win after %s1:0%s2 minutes", max_enemy_timeout / 60, max_enemy_timeout % 60), true);
			else
				SetPlayerStatus(player, 2, Translatef("You win after %s1:%s2 minutes", max_enemy_timeout / 60, max_enemy_timeout % 60), true);
		}

	//as long as at least 1 townhall is owned, timer before defeat does not start
	if (owned_townhalls.IsEmpty()) {
		SetPlayerStatus(player, 0, true);
		if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
			time_to_survive = 0;
			continue;
		}
		if (time_to_survive == -1)
			time_to_survive = elimination_timeout;
		EnvWriteInt(player, "elimination", time_to_survive);
		if (time_to_survive % 60 < 10)
			SetPlayerStatus(player, 1, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);
		else
			SetPlayerStatus(player, 1, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);
		time_to_survive -= 1;
	}
	else {
		EnvWriteInt(player, "elimination", 0);//managed to recapture (or defeat timer has not started yet)
		time_to_survive = -1;
	}

	Sleep(1000);
}