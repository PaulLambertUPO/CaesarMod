//void, int player, str param

int i, n, time_limit, sudden_death_timeout, elimination_timeout, team_score, top_score_1, top_score_2, time_to_survive, max_enemy_timer, enemy_timer;
bool enemies_losing, sudden_death_started = false;

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

time_limit = Str2Int(param);
sudden_death_timeout = GetConst("SuddenDeathTimeout");
elimination_timeout = GetConst("EliminationTimeout");
time_to_survive = -1;

EnvWriteInt(player, "elimination", 0);

SetPlayerStatus(player, 0, Translatef("Time limit (%s1 minutes) - Score", time_limit / 60), false);

while (1) {
	//hide upper right corner messages
	SetPlayerStatus(player, 0, false);//game mode
	SetPlayerStatus(player, 1, false);//game conditions
	SetPlayerStatus(player, 2, false);//defeat timer
	SetPlayerStatus(player, 3, false);//victory timer

	if (time_to_survive == 0) {
		SetPlayerStatus(player, 0, true);
		SetPlayerStatus(player, 1, true);
		SetPlayerStatus(player, 2, Translate("You were eliminated"), true);
		SetPlayerStatus(player, 3, true);
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
				SetPlayerStatus(player, 3, Translatef("You win after %s1:0%s2 minutes", max_enemy_timer / 60, i), true);
			else
				SetPlayerStatus(player, 3, Translatef("You win after %s1:%s2 minutes", max_enemy_timer / 60, i), true);
		}
	}
	else
		SetPlayerStatus(player, 3, "", false);

	//calculate all teams/players scores
	top_score_1 = -1;
	top_score_2 = -1;
	for (i = 1; i <= 8; i += 1) {
		n = GetTeamOverallScore(i);
		if (i == player)
			team_score = n;
		if (n > top_score_2)
			if (n > top_score_1) {
				top_score_2 = top_score_1;
				top_score_1 = n;
			}
			else
				top_score_2 = n;
	}
	if (top_score_2 < 0)
		top_score_2 = top_score_1;

	//sudden death timer starts when general timer reaches 0 but two teams have the same score
	if (!sudden_death_started)
		if (time_limit > 0) {
			if (time_limit <= 600) {
				SetPlayerStatus(player, 0, true);
				i = time_limit % 60;
				if (i < 10)
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:0%s2 minutes left)", time_limit / 60, i), true);
				else
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:%s2 minutes left)", time_limit / 60, i), true);
			}
		}
		else if (top_score_1 == top_score_2)
			sudden_death_started = true;
		else {
			SetPlayerStatus(player, 0, true);
			SetPlayerStatus(player, 2, true);
			if (top_score_1 == team_score) {
				SetPlayerStatus(player, 1, Translate("You won!"), true);
				EnvWriteInt(player, "elimination", 0);
				EndGame(player, false);
			}
			else {
				SetPlayerStatus(player, 1, Translate("You lost"), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true);
			}
			return;
		}

	if (sudden_death_started) {
		SetPlayerStatus(player, 0, true);
		if (sudden_death_timeout <= 0) {
			SetPlayerStatus(player, 2, true);
			if (top_score_1 == team_score) {
				SetPlayerStatus(player, 1, Translate("You won!"), true);
				EnvWriteInt(player, "elimination", 0);
				EndGame(player, false);
			}
			else {
				SetPlayerStatus(player, 1, Translate("You lost"), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true);
			}
			return;
		}
		i = sudden_death_timeout % 60;
		if (i < 10)
			SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:0%s2)", sudden_death_timeout / 60, i), true);
		else
			SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:%s2)", sudden_death_timeout / 60, i), true);

		if (Strongholds(player) <= 0) {//as long as at least 1 townhall is owned, timer before defeat does not start
			if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
				time_to_survive = 0;
				continue;
			}
			if (time_to_survive == -1)
				time_to_survive = elimination_timeout;
			i = time_to_survive % 60;
			if (i < 10)
				SetPlayerStatus(player, 2, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, i), true);
			else
				SetPlayerStatus(player, 2, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, i), true);
			EnvWriteInt(player, "elimination", MIN(time_to_survive, sudden_death_timeout));
			time_to_survive -= 1;
		}
		else {//managed to recapture (or defeat timer has not started yet)
			if (time_to_survive != -1) {
				SetPlayerStatus(player, 2, "", false);
				time_to_survive = -1;
			}
			EnvWriteInt(player, "elimination", sudden_death_timeout);
		}

		sudden_death_timeout -= 1;
	}
	else if (Strongholds(player) <= 0) {//as long as at least 1 townhall is owned, timer before defeat does not start
		if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
			time_to_survive = 0;
			continue;
		}
		if (time_to_survive == -1)
			time_to_survive = elimination_timeout;
		SetPlayerStatus(player, 0, true);
		i = time_to_survive % 60;
		if (i < 10)
			SetPlayerStatus(player, 2, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, i), true);
		else
			SetPlayerStatus(player, 2, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, i), true);
		EnvWriteInt(player, "elimination", time_to_survive);
		time_to_survive -= 1;
	}
	else if (time_to_survive != -1) {//managed to recapture//managed to recapture (or defeat/sudden_death timer has not started yet)
		SetPlayerStatus(player, 2, "", false);
		EnvWriteInt(player, "elimination", 0);
		time_to_survive = -1;
	}

	time_limit -= 1;
	Sleep(1000);
}