//void, int player, str param

Query owned_townhalls;
int elimination_timeout, sudden_death_timeout, team_score;
int i, time_limit, top_score_1, top_score_2, time_to_survive, max_enemy_timeout;
bool enemies_losing, sudden_death_started = false;

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

time_limit = Str2Int(param);
sudden_death_timeout = GetConst("SuddenDeathTimeout");
elimination_timeout = GetConst("EliminationTimeout");
time_to_survive = -1;

EnvWriteInt(player, "elimination", 0);

SetPlayerStatus(player, 0, Translatef("Time limit (%s1 minutes) - Score", time_limit / 60), false);
Sleep(10);

while (1) {
	//hide upper right corner messages
	SetPlayerStatus(player, 0, false);//game mode
	SetPlayerStatus(player, 1, false);//game conditions
	SetPlayerStatus(player, 2, false);//defeat timer
	SetPlayerStatus(player, 3, false);//victory timer

	if (time_to_survive == 0) {
		SetPlayerStatus(player, 0, true);
		SetPlayerStatus(player, 1, Translate("You were eliminated"), true);
		SetPlayerStatus(player, 2, false);
		SetPlayerStatus(player, 3, false);
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
				SetPlayerStatus(player, 3, Translatef("You win after %s1:0%s2 minutes", max_enemy_timeout / 60, max_enemy_timeout % 60), true);
			else
				SetPlayerStatus(player, 3, Translatef("You win after %s1:%s2 minutes", max_enemy_timeout / 60, max_enemy_timeout % 60), true);
		}

	//calculate all teams/players scores
	team_score = GetTeamOverallScore(player);
	top_score_1 = -1;
	top_score_2 = -1;
	for (i = 1; i <= 8; i += 1) {
		int n;
		n = GetTeamOverallScore(i);
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
	if (!sudden_death_started) {
		if (time_limit > 0) {
			bool low_timer;
			low_timer = time_limit <= 600;//10 minutes
			SetPlayerStatus(player, 0, low_timer);
			if (time_limit % 60 < 10)
				SetPlayerStatus(player, 1, Translatef("Time limit (%s1:0%s2 minutes left)", time_limit / 60, time_limit % 60), low_timer);
			else
				SetPlayerStatus(player, 1, Translatef("Time limit (%s1:%s2 minutes left)", time_limit / 60, time_limit % 60), low_timer);
		}
		else {
			if (top_score_1 == top_score_2)
				sudden_death_started = true;
			else {
				SetPlayerStatus(player, 0, true);
				SetPlayerStatus(player, 2, false);
				SetPlayerStatus(player, 3, false);
				if (team_score == top_score_1) {
					SetPlayerStatus(player, 1, Translate("You won!"), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, false);
				}
				else {
					SetPlayerStatus(player, 1, Translate("You lost"), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, true);
				}
				return;
			}
		}
	}
	if (sudden_death_started) {
		SetPlayerStatus(player, 0, true);
		if (sudden_death_timeout <= 0) {
			SetPlayerStatus(player, 2, false);
			SetPlayerStatus(player, 3, false);
			if (team_score == top_score_1) {
				SetPlayerStatus(player, 1, Translate("You won!"), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, false);
			}
			else {
				SetPlayerStatus(player, 1, Translate("You lost"), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true);
			}
			return;
		}
		if (sudden_death_timeout % 60 < 10)
			SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:0%s2)", sudden_death_timeout / 60, sudden_death_timeout % 60), true);
		else
			SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:%s2)", sudden_death_timeout / 60, sudden_death_timeout % 60), true);

		if (owned_townhalls.IsEmpty()) {
			if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
				time_to_survive = 0;
				continue;
			}
			if (time_to_survive == -1)
				time_to_survive = elimination_timeout;
		}
		else
			time_to_survive = -1;

		if (time_to_survive > -1)
			if (time_to_survive % 60 < 10)
				SetPlayerStatus(player, 2, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);
			else
				SetPlayerStatus(player, 2, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);

		EnvWriteInt(player, "elimination", MIN(time_to_survive, sudden_death_timeout));
		time_to_survive -= 1;
		sudden_death_timeout -= 1;
	}
	else if (owned_townhalls.IsEmpty()) {//as long as at least 1 townhall is owned, timer before defeat does not start
		SetPlayerStatus(player, 0, true);
		if (MilUnits(player) <= 0) {//if no units can recapture a townhall, defeat is immediate
			time_to_survive = 0;
			continue;
		}
		if (time_to_survive == -1)
			time_to_survive = elimination_timeout;
		EnvWriteInt(player, "elimination", time_to_survive);
		if (time_to_survive % 60 < 10)
			SetPlayerStatus(player, 2, Translatef("You lose after %s1:0%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);
		else
			SetPlayerStatus(player, 2, Translatef("You lose after %s1:%s2 minutes", time_to_survive / 60, time_to_survive % 60), true);
		time_to_survive -= 1;
	}
	else {
		EnvWriteInt(player, "elimination", 0);//managed to recapture (or sudden death timer has not started yet)
		time_to_survive = -1;
	}

	time_limit -= 1;
	Sleep(1000);
}