//void, Settlement set

int Greece, AIPlayer, nRace, nSquanderGoldAmount, nExcessGold, nTradeGold, nTradeFood, nTrainStart, nArenaHire, nSleepES;
str maxUpgradeBarracks;
bool tactic_finished = true;

Sleep(2000 + rand(501));//sleep must be higher than tactic script initial sleep (1000)

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;
EnvWriteInt(set, "nArmyBuilds", 0);//the amount of times ESH_BuildArmy has been called
EnvWriteInt(set, "ResearchTechTime", GetTime());//time of the next allowed research for ESH_NeedTech

if (EnvReadInt(set, "ChooseRomanRace") != 1) {
	int nRome;
	nRome = rand(3);
	if (nRome == 0)
		set.Research("ChooseRepublicanRome");
	else if (nRome == 1)
		set.Research("ChooseImperialRome");
	else
		set.Research("ChoosePunicRome");
}

//store these values because they are constant and it is not good to retrieve them from AI variables every time
nSquanderGoldAmount = AIVar(AIPlayer, AIV_SquanderGoldAmount);
nExcessGold = AIVar(AIPlayer, AIV_ExcessGold);
maxUpgradeBarracks = "Barrack Level " + AIVar(AIPlayer, AIV_UpgradeBarracks);
nTradeGold = AIVar(AIPlayer, AIV_TradeGold);
nTradeFood = AIVar(AIPlayer, AIV_TradeFood);
nTrainStart = AIVar(AIPlayer, AIV_Training);
nArenaHire = AIVar(AIPlayer, AIV_ArenaHire);
nSleepES = AIVar(AIPlayer, AIV_Sleep_ES);

//normalize the value of nTradeFood in case the AI variable value is below 1100 (result of 1000 + GetConst("MinResQtyToTransport"))
if (nTradeFood > 0)
	nTradeFood = MAX(nTradeFood, 1100);

//decide sequence of research for advanced units for when there is a lot of gold
if (nRace != Carthage)
	if (nRace != Germany)
		if (EnvReadInt(set, "TechSeq" + AIPlayer + "_Initted") == 0)
			set.AIRun("ESH_ArmyTechSeq.vs");

//avoid using tactic if the map is small
if (MapSize() >= 16000)
	tactic_finished = AIVar(AIPlayer, AIV_WaitTactic) != 1;

while (set.player == AIPlayer) {
	if (tactic_finished) {
		int nMilUnits, nEnemyMilEval, nMinEnemyEval, nMaxEnemyEval, nAverEnemyEval, nFreezeArmyBuild, i;
		bool bEnemies, bAssUnderFire, bResearchTrainingComplete;

		nMilUnits = MilUnits(AIPlayer);
		nEnemyMilEval = EnemyPlayersEval(AIPlayer, nMinEnemyEval, nMaxEnemyEval, nAverEnemyEval);

		i = MAX(nMilUnits / Strongholds(AIPlayer), set.Units.count);
		EnvWriteInt(set, "nFoodReserve", i * 15);//used in ESH_Market and ESH_ArenaUnits

		nFreezeArmyBuild = EnvReadInt(set, "FreezeArmyBuild");
		if (nFreezeArmyBuild > 0) {
			nFreezeArmyBuild -= 1;
			EnvWriteInt(set, "FreezeArmyBuild", nFreezeArmyBuild);
		}

		{
			int nOwn, nAlly, nEnemy, enemy_hidden;
			set.GetGaika().Eval(AI_ALL, AIPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
			bEnemies = nEnemy > 0;
			bAssUnderFire = nEnemy > nOwn + nAlly;
		}
		if (bAssUnderFire) {
			int nAssUnderFire;
			nAssUnderFire = 1 + EnvReadInt(set, "AssUnderFire");
			EnvWriteInt(set, "AssUnderFire", nAssUnderFire);
			if (nAssUnderFire > 10) {
				set.StopReserving();
				EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
			}
		}
		else
			EnvWriteInt(set, "AssUnderFire", 0);

		//chance to give higher priority to arena units based on the upgrade level reached (0 -> 1/70, 1 -> 1/40, 2 -> 1/10)
		if (rand(70 - EnvReadInt(set, "ArenaResearchLevel") * 30) == 0)
			set.AIRun("ESH_ArenaUnits.vs");

		//recruit heroes and/or military units
		set.AIRun("ESH_ArmyRecruitment.vs");

		//research something to improve the army when there is a lot of gold in the stronghold
		if (set.gold >= nExcessGold)
			set.AIRun("ESH_ExpensiveTechs.vs");

		//improve stronghold defences/gates
		if (!IsResearched(set, "Strenghten Stronghold Defences I")) {
			if (set.gold >= nSquanderGoldAmount || GetTime() >= 60000 * AIVar(AIPlayer, AIV_TimeStrongholdDefences1)) {
				EnvWriteString(set, "strTech", "Strenghten Stronghold Defences I");
				set.AIRun("ESH_NeedTech.vs");
			}
		}
		else if (!IsResearched(set, "Strenghten Stronghold Defences II")) {
			if (set.gold >= nSquanderGoldAmount || GetTime() >= 60000 * AIVar(AIPlayer, AIV_TimeStrongholdDefences2)) {
				EnvWriteString(set, "strTech", "Strenghten Stronghold Defences II");
				set.AIRun("ESH_NeedTech.vs");
			}
		}
		if (nRace == Greece)
			if (!IsResearched(set, "Strengthen Stronghold Gates"))
				if (set.gold >= nSquanderGoldAmount || GetTime() >= 60000 * AIVar(AIPlayer, AIV_TimeStrongholdGates)) {
					EnvWriteString(set, "strTech", "Strengthen Stronghold Gates");
					set.AIRun("ESH_NeedTech.vs");
				}

		//barrack upgrades
		if (!bAssUnderFire)
			if (set.gold >= 500)
				if (!IsResearched(set, maxUpgradeBarracks))
					set.AIRun("ESH_UpgradeBarracks.vs");

		//tavern and defensive townhall researches/commands
		set.AIRun("ESH_Market.vs");

		//gold and food trade
		if (MilEval(AIPlayer) >= nAverEnemyEval) {
			if (nTradeGold > 0)
				if (set.gold >= 1000)
					if (EnvReadInt(AIPlayer, "GoldTradeOutposts") < nTradeGold)
						set.AIRun("ESH_GoldTrade.vs");
			if (nTradeFood > 0)
				if (set.food >= nTradeFood)
					set.AIRun("ESH_FoodTrade.vs");
		}

		//research training upgrades and then combat magic, druids and arena units
		if (set.gold >= nSquanderGoldAmount || !bAssUnderFire && nMilUnits >= nTrainStart || rand(50) == 0)
			set.AIRun("ESH_ResearchTraining.vs");

		bResearchTrainingComplete = EnvReadInt(set, "ResearchTrainingComplete") != 0;
		if (set.gold >= nSquanderGoldAmount || !bAssUnderFire && bResearchTrainingComplete || rand(70) == 0)
			set.AIRun("ESH_CombatMagic.vs");
		if (!bAssUnderFire && set.gold >= 1000 || set.gold >= nSquanderGoldAmount)
			if (set.gold >= nSquanderGoldAmount || nMilUnits >= 20 && bResearchTrainingComplete || rand(60) == 0)
				set.AIRun("ESH_Druids.vs");
		if (set.gold >= nSquanderGoldAmount || !bAssUnderFire && bResearchTrainingComplete && nMilUnits >= nArenaHire || rand(40) == 0)
			set.AIRun("ESH_ArenaUnits.vs");

		//repair fortress
		if (!bEnemies)
			set.RepairAll();
	}
	else {//after 7 minutes, stop waiting for tactic in order to unlock stronghold management
		if (GetTime() >= 420000)
			SetAIVar(AIPlayer, AIV_WaitTactic, 0);
		tactic_finished = AIVar(AIPlayer, AIV_WaitTactic) != 1;
	}
	Sleep(nSleepES);
}
SetAIVar(AIPlayer, AIV_WaitTactic, 0);//this is to stop the tactic script if the stronghold is captured before it ends (difficult but not impossible)