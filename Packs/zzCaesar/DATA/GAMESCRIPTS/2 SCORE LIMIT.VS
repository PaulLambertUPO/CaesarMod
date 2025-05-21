//void, int player, str param

Query owned_townhalls;
int score_limit, near_score_percent, score_delta, sudden_death_timeout, elimination_timeout;
int i, team_score, top_score_1, top_score_2, time_to_survive, max_enemy_timeout;
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

score_limit = Str2Int(param);
near_score_percent = GetConst("NearScorePercent");
score_delta = GetConst("ScoreDelta");
sudden_death_timeout = GetConst("SuddenDeathTimeout");
elimination_timeout = GetConst("EliminationTimeout");
time_to_survive = -1;

EnvWriteInt(player, "elimination", 0);

SetPlayerStatus(player, 0, Translatef("Score limit (%s1)", score_limit), false);
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

	//sudden death timer starts when a team reaches the limit but with a delta not big enough to win instantly
	if (!sudden_death_started) {
		if (team_score < score_limit) {//no ally has reached the limit
			if (top_score_1 >= score_limit) {//an enemy has reached the limit
				if (top_score_1 - top_score_2 >= score_delta) {//defeat is immediate if the delta is big enough, otherwise sudden death starts
					SetPlayerStatus(player, 0, true);
					SetPlayerStatus(player, 1, Translate("You lost"), true);
					SetPlayerStatus(player, 2, false);
					SetPlayerStatus(player, 3, false);
					EndGame(player, true);
					return;
				}
				else
					sudden_death_started = true;
			}
			else if (top_score_1 >= near_score_percent * score_limit / 100) {//if someone (either ally or enemy) is reaching the limit, show a message in the upper right corner
				SetPlayerStatus(player, 0, true);
				if (top_score_1 == team_score)
					SetPlayerStatus(player, 1, Translatef("You're winning (%s1/%s2)", top_score_1, score_limit), true);
				else
					SetPlayerStatus(player, 1, Translatef("You're losing (%s1/%s2)", top_score_1, score_limit), true);
			}
		}
		else if (top_score_1 - top_score_2 >= score_delta) {//game is over: an ally has reached the limit and the delta is big enough, but the top 1 might be an enemy team
			SetPlayerStatus(player, 0, true);
			SetPlayerStatus(player, 2, false);
			SetPlayerStatus(player, 3, false);
			if (top_score_1 == team_score) {
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
		else
			sudden_death_started = true;//an ally has reached the limit but the delta is not big enough
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

	Sleep(1000);
}