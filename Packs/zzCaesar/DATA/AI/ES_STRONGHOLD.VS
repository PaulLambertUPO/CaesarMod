//void, Settlement set

GAIKA g;
int aiPlayer, nSquanderGoldAmount, nTradeGold, nTradeFood, nTrainStart, nArenaHire, nSleepES;
int nMilUnits, nMinEnemyEval, nMaxEnemyEval, nAvgEnemyEval, nFreezeArmyBuild, nOwn, nAlly, nEnemy, enemy_hidden;
str maxUpgradeBarracks, reservedStrTech;
bool bAssUnderFire, bResearchTrainingComplete, bCanResearchSentryUpgrades = false, nRaceIsGreece = false;

Sleep(2500 + rand(501));//sleep must be higher than tactic script initial sleep (1000) and max allowed time (2000)

aiPlayer = set.player;

g = set.GetGaika();

EnvWriteInt(set, "nArmyBuilds", 0);//the amount of times ESH_BuildArmy has been called
EnvWriteInt(set, "ResearchTechTime", GetTime());//time of the next allowed research for ESH_NeedTech
EnvWriteInt(set, "ResearchTrainingComplete", 0);//flag used by ESH_ResearchTraining to research upgrades (reset here to prevent a new owner from ignoring player upgrades)

//store these values because they are constant and it is not good to retrieve them from AI variables every time
nSquanderGoldAmount = AIVar(aiPlayer, AIV_SquanderGoldAmount);
maxUpgradeBarracks = "Barrack Level " + AIVar(aiPlayer, AIV_UpgradeBarracks);
nTradeGold = AIVar(aiPlayer, AIV_TradeGold);
nTradeFood = AIVar(aiPlayer, AIV_TradeFood);
nTrainStart = AIVar(aiPlayer, AIV_Training);
nArenaHire = AIVar(aiPlayer, AIV_ArenaHire);
nSleepES = AIVar(aiPlayer, AIV_Sleep_ES);

//normalize the value of nTradeFood in case the AI variable value is below 1100 (result of 1000 + GetConst("MinResQtyToTransport"))
if (nTradeFood > 0)
	if (nTradeFood < 1100)
		nTradeFood = 1100;

{
	ObjList ol;
	Obj o;
	int i;

	ol = set.Buildings;

	for (i = ol.count - 1; i >= 0; i -= 1) {
		o = ol[i];
		if (o.AsGate().IsValid) {
			bCanResearchSentryUpgrades = true;
			break;
		}
		if (o.IsHeirOf("Wall")) {
			bCanResearchSentryUpgrades = true;
			break;
		}
	}
}

if (EnvReadInt(set, "ChooseRomanRace") != 1) {//no check on townhall race is to manage possible Roman buildings in hybrid settlements (although they are not managed)
	int nRome;
	nRome = rand(3);
	if (nRome == 0) {
		if (set.CanResearch("ChooseRepublicanRome"))
			set.Research("ChooseRepublicanRome");
	}
	else if (nRome == 1) {
		if (set.CanResearch("ChooseImperialRome"))
			set.Research("ChooseImperialRome");
	}
	else if (set.CanResearch("ChoosePunicRome"))
		set.Research("ChoosePunicRome");
	Sleep(500);//give some time to the settlement to register the chosen Rome
}

{
	Building hall;
	int nRace;

	hall = set.GetCentralBuilding();

	//decide sequence of researches for advanced units for when there is a lot of gold
	nRace = hall.race;
	if (nRace != Carthage)
		if (nRace != Germany) {
			nRaceIsGreece = nRace == ImperialRome;
			if (EnvReadInt(set, "TechSeq" + aiPlayer + "_Initted") == 0)
				set.AIRun("ESH_ArmyTechSeq.vs");
		}

	//wait for the tactic to end (normal completion, stronghold captured, max time reached or enemies near the townhall)
	while (AIVar(aiPlayer, AIV_WaitTactic) == 1) {
		if (set.player != aiPlayer)
			SetAIVar(aiPlayer, AIV_WaitTactic, 0);
		else if (GetTime() >= 420000)
			SetAIVar(aiPlayer, AIV_WaitTactic, 0);
		else if (!Intersect(VisibleObjsInSight(hall, "Military"), EnemyObjs(aiPlayer, "Military")).IsEmpty)
			SetAIVar(aiPlayer, AIV_WaitTactic, 0);
		Sleep(nSleepES);
	}
}

while (set.player == aiPlayer) {
	nMilUnits = MilUnits(aiPlayer);
	EnemyPlayersEval(aiPlayer, nMinEnemyEval, nMaxEnemyEval, nAvgEnemyEval);

	EnvWriteInt(set, "nFoodReserve", 15 * MAX(set.Units.count, nMilUnits / Strongholds(aiPlayer)));//used in ESH_Market and ESH_ArenaUnits

	reservedStrTech = EnvReadString(set, "ReserveFor" + (aiPlayer - 1));//unlock army recruitment in case a reserved tech is researched by another stronghold
	if (reservedStrTech != "")//do not use IsResearched here because there might be some commands with a name/token that would not comply (e.g. tribute)
		if (EnvReadString(set, reservedStrTech) == "researched") {
			set.StopReserving();
			EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
			EnvWriteInt(set, "FreezeArmyBuild", 0);
		}
		else if (EnvReadString(aiPlayer, reservedStrTech) == "researched") {
			set.StopReserving();
			EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
			EnvWriteInt(set, "FreezeArmyBuild", 0);
		}

	nFreezeArmyBuild = EnvReadInt(set, "FreezeArmyBuild");
	if (nFreezeArmyBuild > 0) {
		nFreezeArmyBuild -= 1;
		EnvWriteInt(set, "FreezeArmyBuild", nFreezeArmyBuild);
	}

	g.Eval(AI_ALL, aiPlayer, nOwn, nAlly, nEnemy, enemy_hidden);
	if (nEnemy > nOwn + nAlly) {
		int nAssUnderFire;
		bAssUnderFire = true;
		nAssUnderFire = 1 + EnvReadInt(set, "AssUnderFire");
		EnvWriteInt(set, "AssUnderFire", nAssUnderFire);
		if (nAssUnderFire > 10) {
			set.StopReserving();
			EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
		}
	}
	else {
		bAssUnderFire = false;
		EnvWriteInt(set, "AssUnderFire", 0);
	}

	//chance to give higher priority to arena units based on the upgrade level reached (0 -> 1/100, 1 -> 1/65, 2 -> 1/30)
	if (rand(100 - EnvReadInt(set, "ArenaResearchLevel") * 35) == 0)
		set.AIRun("ESH_ArenaUnits.vs");

	//recruit heroes and/or military units
	set.AIRun("ESH_ArmyRecruitment.vs");

	//research something when there is a lot of gold in the stronghold
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_SquanderGoldTechs.vs");

	//improve stronghold defences/walls and hire sentries (Greece)
	if (bCanResearchSentryUpgrades) {
		if (!IsResearched(set, "Strengthen Stronghold Defences II"))
			if (GetTime() >= 60000 * AIVar(aiPlayer, AIV_TimeStrongholdDefences)) {//no constant to avoid wasting memory after the research
				EnvWriteString(set, "strTech", "Strengthen Stronghold Defences II");
				set.AIRun("ESH_NeedTech.vs");
			}
			else if (set.gold >= nSquanderGoldAmount) {
				EnvWriteString(set, "strTech", "Strengthen Stronghold Defences II");
				set.AIRun("ESH_NeedTech.vs");
			}
		if (nRaceIsGreece) {
			if (!IsResearched(set, "Strengthen Stronghold Walls"))
				if (GetTime() >= 60000 * AIVar(aiPlayer, AIV_TimeStrongholdWalls)) {//no constant to avoid wasting memory after the research
					EnvWriteString(set, "strTech", "Strengthen Stronghold Walls");
					set.AIRun("ESH_NeedTech.vs");
				}
				else if (set.gold >= nSquanderGoldAmount) {
					EnvWriteString(set, "strTech", "Strengthen Stronghold Walls");
					set.AIRun("ESH_NeedTech.vs");
				}
			if (bAssUnderFire)
				if (rand(2) == 0)
					if (GetTime() >= 300000)//avoid hiring sentries as soon as the game starts
						if (set.GetNumSentries() < set.GetMaxSentries() / 3)//total max = 20 for townhall + 1 per wall + 4 per gate (usually 50-52)
							if (set.CanResearch("hire_sentries"))
								if (set.CanAfford("hire_sentries")) {
									int gold, food;
									if (GetCmdCost("hire_sentries", gold, food)) {
										set.SpentGoldOnArmy(gold + food / 2);
										set.Research("hire_sentries");
									}
								}
		}
	}

	//barrack upgrades
	if (!bAssUnderFire)
		if (set.gold >= 500)
			if (!IsResearched(set, maxUpgradeBarracks))
				set.AIRun("ESH_UpgradeBarracks.vs");

	//tavern and defensive townhall researches/commands
	set.AIRun("ESH_Market.vs");

	//gold and food trade
	if (MilEval(aiPlayer) >= nAvgEnemyEval) {
		if (nTradeGold > 0)
			if (set.gold >= 1000)
				if (EnvReadInt(aiPlayer, "GoldTradeOutposts") < nTradeGold)
					if (EnvReadInt(aiPlayer, "GoldTradeStartInProgress") != 1)
						set.AIRun("ESH_GoldTrade.vs");
		if (nTradeFood > 0)
			if (set.food >= nTradeFood)
				if (GetTime() >= EnvReadInt(set, "FoodTradeMuleWait"))
					set.AIRun("ESH_FoodTrade.vs");
	}

	//research various upgrades
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_ResearchTraining.vs");
	else if (rand(50) == 0)
		set.AIRun("ESH_ResearchTraining.vs");
	else if (!bAssUnderFire)
		if (nMilUnits >= nTrainStart)
			set.AIRun("ESH_ResearchTraining.vs");

	bResearchTrainingComplete = EnvReadInt(set, "ResearchTrainingComplete") == 1;

	//research combat magic upgrades
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_CombatMagic.vs");
	else if (rand(70) == 0)
		set.AIRun("ESH_CombatMagic.vs");
	else if (bResearchTrainingComplete)
		if (!bAssUnderFire)
			set.AIRun("ESH_CombatMagic.vs");

	//train sages
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_Druids.vs");
	else if (!bAssUnderFire)
		if (set.gold >= 1000)
			if (rand(60) == 0)
				set.AIRun("ESH_Druids.vs");
			else if (bResearchTrainingComplete)
				if (nMilUnits >= 20)
					set.AIRun("ESH_Druids.vs");

	//train arena units and research their upgrades
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_ArenaUnits.vs");
	else if (rand(40) == 0)
		set.AIRun("ESH_ArenaUnits.vs");
	else if (bResearchTrainingComplete)
		if (!bAssUnderFire)
			if (nMilUnits >= nArenaHire)
				set.AIRun("ESH_ArenaUnits.vs");

	//unlock more army units
	if (set.gold >= nSquanderGoldAmount)
		set.AIRun("ESH_ArmyTechs.vs");
	else if (rand(80) == 0)
		set.AIRun("ESH_ArmyTechs.vs");
	else if (bResearchTrainingComplete)
		if (!bAssUnderFire)
			set.AIRun("ESH_ArmyTechs.vs");

	//repair stronghold
	if (nEnemy <= 0)
		set.RepairAll();

	Sleep(nSleepES);
}