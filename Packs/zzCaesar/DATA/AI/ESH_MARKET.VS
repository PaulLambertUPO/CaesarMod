//void, Settlement set

//called by ES_Stronghold, this script manages most tavern and townhall researches
//be careful: research commands to be issued to the settlement sometimes have different names from what they set in the player/settlement environment

int Greece, AIPlayer, nRace, nAssUnderFire, nFoodReserve, nMilUnits, i, gold, food;
str strTech = "";
StrArray strTechMarket;
Building bld;
bool bFirstTechDone, bForceResearch = false, bWantTribute = false, bSlaves = false;
point ptDummy;
Obj objDummy;

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold
nFoodReserve = EnvReadInt(set, "nFoodReserve");//set in ES_Stronghold
nMilUnits = MilUnits(AIPlayer);

strTechMarket[Gaul] = "Free Beer";
strTechMarket[RepublicanRome] = "Free Wine";
strTechMarket[Carthage] = "Free Trade";
strTechMarket[Iberia] = "Free Drinks";
strTechMarket[Greece] = "Trade Routes";
strTechMarket[Britain] = "Gambling";
strTechMarket[Egypt] = "Grain Trade";
strTechMarket[Germany] = "TGrainTrade";

bFirstTechDone = IsResearched(set, strTechMarket[nRace]);

if (!bFirstTechDone)
	if (nRace == Germany) {
		if (set.food >= AIVar(AIPlayer, AIV_SquanderFoodAmount))
			strTech = strTechMarket[nRace];
	}
	else if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
		strTech = strTechMarket[nRace];

//buy food; the random for Carthage is to reduce the chance of a sell/buy food command loop
if (set.food < 2500)
	if (nRace == Germany || nRace == Carthage && rand(2) == 0 || nRace == RepublicanRome && (IsResearched(set, "ChooseRepublicanRome") || IsResearched(set, "ChoosePunicRome"))) {
		str cmd = "buyfoodforgold";
		if (set.CanAfford(cmd))
			if (set.food < 200 || rand(5) == 0 || nRace == Germany && set.gold >= set.food * 3 && rand(2) == 0) {
				bld = set.FindResearchLab(cmd);
				if (bld.IsValid)
					if (bld.CmdCount(cmd) < 2) {
						GetCmdCost(cmd, gold, food);
						set.SpentGoldOnTech(gold + food / 2);
						bld.ExecCmd(cmd, ptDummy, objDummy, false);
					}
			}
	}

//townhall - heal (Iberia and Egypt) and refreshment (Gaul and Britain) - heal is always handy, refreshment only in danger
if (rand(2) == 0)
	if (nRace == Iberia || nRace == Egypt || nAssUnderFire >= 10 && (nRace == Gaul || nRace == Britain)) {
		bld = set.GetCentralBuilding();
		if (bld.IsValid) {
			Query qAll, qEnemy, qAlly;
			ObjList olAlly;
			int bldRange;

			bldRange = bld.sight * 3 / 2;
			qAll = ObjsInRange(bld, "Military", bldRange);
			qEnemy = Intersect(qAll, EnemyObjs(AIPlayer, "Military"));
			olAlly = Subtract(qAll, qEnemy).GetObjList();

			if (!qEnemy.IsEmpty()) {
				int ownEval, allyEval, enemyEval, diffEval;

				Eval(AIPlayer, bld.pos, bldRange, ownEval, allyEval, enemyEval);
				diffEval = ownEval + allyEval - enemyEval;

				if (diffEval >= -500 && diffEval <= 500 || ownEval + allyEval < 2 * enemyEval) {
					int nHealth, nMaxHealth, nStamina, nMaxStamina;
					str cmd;

					for (i = 0; i < olAlly.count; i += 1) {
						Unit u;
						u = olAlly[i].AsUnit();
						if (u.IsValid)
							if (u.IsAlive) {
								nHealth += u.health;
								nMaxHealth += u.maxhealth;
								nStamina += u.stamina;
								nMaxStamina += u.maxstamina;
							}
					}
					if (nRace == Iberia || nRace == Egypt) {
						if (nHealth <= nMaxHealth / 2)
							cmd = "heal";
					}
					else if (nRace == Gaul || nRace == Britain)
						if (nStamina <= nMaxStamina / 2)
							cmd = "refreshment";

					if (cmd != "")
						if (set.CanResearch(cmd))
							if (set.CanAfford(cmd)) {
								GetCmdCost(cmd, gold, food);
								set.SpentGoldOnTech(gold + food / 2);
								set.Research(cmd);
							}
				}
			}
		}
	}

//townhall - add sentries (Greece) - avoid hiring them as soon as the game starts
if (nRace == Greece)
	if (nAssUnderFire >= 10)
		if (set.gold >= 2000)
			if (rand(2) == 0)
				if (GetTime() >= 300000) {
					int curr, max;
					str cmd = "hire_sentries";
					curr = set.GetNumSentries();
					max = set.GetMaxSentries();//total max = InitialStrongholdSentries + 1 per wall + 4 per gate (with const = 20, total max is usually 50-52)
					if (curr <= max / 3)
						if (set.CanAfford(cmd))
							if (!Intersect(ObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(AIPlayer, "Military")).IsEmpty()) {
								GetCmdCost(cmd, gold, food);
								set.SpentGoldOnTech(gold + food / 2);
								set.Research(cmd);
							}
				}

//tribute
if (strTech == "")
	if (nAssUnderFire <= 0)
		if (AIVar(AIPlayer, AIV_Tribute) != 0)
			if (EnvReadString(AIPlayer, "Tribute") == "") {
				str cmd;
				if (nRace == Greece)
					cmd = "HTribute";
				else
					cmd = GetRaceStrPref(nRace) + "Tribute";
				bld = set.FindResearchLab(cmd);
				if (bld.IsValid)
					if (bld.CmdCount(cmd) < 1) {
						int nOutposts, nProfit, nNextTime, nNextProfit;
						nOutposts = Outposts(AIPlayer);
						{
							int delay, time;
							str times, values;

							times = GetConstStr("TributeTimes");
							values = GetConstStr("TributeGold");
							delay = GetConst("TributeDuration") * 1000;

							i = GetTime() + delay;

							while (times != "") {
								int old_gold;
								old_gold = gold;
								time = Str2Int(ParseStr(times, times)) * 60000;
								gold = Str2Int(ParseStr(values, values));
								nNextProfit = gold;
								if (i < time) {
									gold = old_gold;
									break;
								}
							}
							nProfit = gold * nOutposts;
							nNextProfit = nNextProfit * nOutposts;
							GetCmdCost(cmd, gold, i);
							nProfit -= gold;
							nNextProfit -= gold;
							nNextTime = time;
						}
						if (nProfit >= 2000)
							if (nProfit >= set.gold || gold >= 2000)
								if (nNextProfit <= nProfit || GetTime() + 60 * (nNextProfit - nProfit) < nNextTime) {
									int nAll, nIndependent;
									nAll = Outposts(0);//All Outposts
									nIndependent = Outposts(15) + Outposts(16);//VX_PLAYER_NEUTRAL + VX_PLAYER_RESCUE
									if (nIndependent < nAll / 10 || nProfit >= 5000) {
										bWantTribute = true;
										bForceResearch = true;
										EnvWriteInt(set, "FreezeArmyBuild", 10);
										if (!bFirstTechDone)
											strTech = strTechMarket[nRace];
										else if (set.CanResearch(cmd))
											if (set.CanAfford(cmd)) {
												GetCmdCost(cmd, gold, food);
												set.SpentGoldOnTech(gold + food / 2);
												bld.ExecCmd(cmd, ptDummy, objDummy, false);
												strTech = "";
												bForceResearch = false;
												if (cmd == EnvReadString(set, "ReserveFor" + (AIPlayer - 1))) {
													set.StopReserving();
													EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
													EnvWriteInt(set, "ReserveCounter", 0);
												}
											}
									}
								}
					}
				if (!bWantTribute)
					if (cmd == EnvReadString(set, "ReserveFor" + (AIPlayer - 1))) {
						set.StopReserving();
						EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
						EnvWriteInt(set, "ReserveCounter", 0);
					}
			}

//investment (Rome)
if (nRace == RepublicanRome)
	if (strTech == "")
		if (nAssUnderFire <= 0)
			if (rand(3) == 0)
				if (GetTime() >= 120000)
					if (EnvReadString(AIPlayer, "Tribute") != "" || !bWantTribute)
						if (!bFirstTechDone)
							strTech = strTechMarket[nRace];
						else {
							str cmd = "investR";
							bld = set.FindResearchLab(cmd);
							if (bld.IsValid)
								if (bld.CmdCount(cmd) < 1)
									if (set.CanAfford(cmd)) {
										GetCmdCost(cmd, gold, food);
										set.SpentGoldOnTech(gold + food / 2);
										bld.ExecCmd(cmd, ptDummy, objDummy, false);
									}
									else if (set.gold >= 3200) {
										strTech = cmd;
										bForceResearch = true;
									}
						}

//grain trade, hecatomb and slavery investment (Egypt)
if (nRace == Egypt)
	if (strTech == "") {
		if (set.food >= 1500 || rand(3) == 0) {
			str cmd = "Grain Trade";
			if (!bFirstTechDone)
				if (set.CanAfford(cmd)) {
					strTech = strTechMarket[nRace];
					bForceResearch = true;
				}
		}
		if (strTech == "")
			if (set.food >= 3000)
				if (set.max_population >= 100)
					if (set.population < set.max_population * 11 / 20)
						if (!bFirstTechDone) {
							strTech = strTechMarket[nRace];
							bForceResearch = true;
						}
						else {
							str cmd = "Hecatomb";
							if (set.CanAfford(cmd)) {
								bld = set.FindResearchLab(cmd);
								if (bld.IsValid)
									if (bld.CmdCount(cmd) < 1) {
										strTech = cmd;
										bSlaves = true;
									}
							}
						}
		if (strTech == "")
			if (rand(2) == 0)
				if (set.gold >= 2500)
					if (set.population <= set.max_population * 2 / 3)
						if (set.SupplyCount("BaseVillage") >= 3)
							if (!bFirstTechDone)
								strTech = strTechMarket[nRace];
							else
								strTech = "Slavery investment";
	}

//religious feast (Egypt, Germany and Greece)
if (strTech == "")
	if (nMilUnits >= 20)
		if (rand(3) == 0)
			if (!IsResearched(set, "Religious Feast"))
				if (nRace == Egypt && set.food >= 2000 || nRace == Germany && set.gold >= 2000 || nRace == Greece && set.gold >= 1500 && set.food >= 1500) {
					str cmd = "HReligiousFeast";
					if (nRace == Egypt)
						cmd = "Religious Feast";
					else if (nRace == Germany)
						cmd = "TReligiousFeast";
					if (set.CanAfford(cmd))
						if (!bFirstTechDone)
							strTech = strTechMarket[nRace];
						else
							strTech = cmd;
				}

//grain trade and fights (Germany)
if (nRace == Germany)
	if (strTech == "") {
		if (!bFirstTechDone) {
			str cmd = "TGrainTrade";
			if (set.CanAfford(cmd))
				strTech = cmd;
		}
		if (strTech == "")
			if (set.food < 2000)
				if (!IsResearched(set, "TFights")) {
					str cmd = "TFights";
					if (set.CanAfford(cmd))
						strTech = cmd;
				}
	}

//food tax (Germany and Gaul)
if (strTech == "")
	if (nRace == Germany || nRace == Gaul)
		if (!IsResearched(set, "Food Tax")) {
			str cmd = "Food Tax";
			if (nRace == Germany)
				cmd = "TFoodTax";
			if (set.CanAfford(cmd)) {
				if (!bFirstTechDone)
					strTech = strTechMarket[nRace];
				else
					strTech = cmd;
				if (nRace == Germany)
					bForceResearch = true;//food tax is extremely important for Germany
			}
		}

//housing 1-2 (Iberia)
if (nRace == Iberia)
	if (strTech == "")
		if (set.population >= set.max_population * 4 / 5)
			if (!IsResearched(set, "Housing") || !IsResearched(set, "More Housing")) {
				str cmd = "Housing";
				if (IsResearched(set, cmd))
					cmd = "More Housing";
				if (set.CanAfford(cmd)) {
					if (!bFirstTechDone)
						strTech = strTechMarket[nRace];
					else
						strTech = cmd;
					if (set.population >= set.max_population)
						bForceResearch = true;
				}
			}

//buy slaves (Greece and Egypt)
if (rand(5) == 0)
	if (set.population <= set.max_population - 15)
		if (nRace == Greece && bFirstTechDone || nRace == Egypt && !bSlaves) {
			str cmd = "HBuySlaves";
			if (nRace == Egypt)
				cmd = "BuySlaves";
			if (set.CanAfford(cmd)) {
				bld = set.FindResearchLab(cmd);
				if (bld.IsValid)
					if (bld.CmdCount(cmd) < 1) {
						GetCmdCost(cmd, gold, food);
						set.SpentGoldOnTech(gold + food / 2);
						bld.ExecCmd(cmd, ptDummy, objDummy, false);
						bSlaves = true;
					}
			}
		}

//add population (all except Egypt)
if (rand(2) == 0)
	if (nRace != Egypt)
		if (nRace != Greece || !bSlaves) {
			str cmd;
			if (nRace == Greece)
				cmd = "HAddPop";
			else
				cmd = GetRaceStrPref(nRace) + "AddPop";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid) {
				int nCmdCount;
				nCmdCount = bld.CmdCount(cmd);
				if (nCmdCount < 2)
					if (set.population + nCmdCount * 10 <= set.max_population - 10)
						if (GetCmdCost(cmd, gold, food))
							if (set.CanAfford(cmd))
								if (set.food - food >= MIN(1200, nFoodReserve / 2)) {
									set.SpentGoldOnTech(gold + food / 2);
									bld.ExecCmd(cmd, ptDummy, objDummy, false);
								}
			}
		}

//foreign mercenaries, mercenary pact, spoils of war, free trade and slavery (Carthage)
if (nRace == Carthage) {
	if (strTech == "") {
		if (bFirstTechDone)
			if (IsResearched(AIPlayer, "Mercenary pact"))
				if (IsResearched(AIPlayer, "Mercenary heal")) {
					str cmd = "Hire foreign mercenaries";
					bld = set.FindResearchLab(cmd);
					if (bld.IsValid)
						if (GetCmdCost(cmd, gold, food))
							if (set.CanAfford(cmd)) {
								set.SpentGoldOnArmy(gold + food / 2);
								bld.ExecCmd(cmd, ptDummy, objDummy, false);
							}
				}
		if (strTech == "")
			if (nMilUnits >= 15)
				if (nAssUnderFire <= 0)
					if (!IsResearched(AIPlayer, "Mercenary pact")) {
						str cmd = "Mercenary pact";
						if (set.CanAfford(cmd))
							if (!bFirstTechDone)
								strTech = strTechMarket[nRace];
							else
								strTech = cmd;
					}
		if (strTech == "")
			if (nAssUnderFire <= 0)
				if (!IsResearched(AIPlayer, "Spoils of war")) {
					str cmd = "People's Assembly";
					if (IsResearched(set, cmd))
						cmd = "Spoils of war";
					if (set.CanResearch(cmd))
						if (nMilUnits >= 20) {
							strTech = cmd;
							bForceResearch = true;
						}
						else if (set.CanAfford(cmd))
							strTech = cmd;
				}
		if (strTech == "")
			if (!bFirstTechDone)
				if (set.population <= set.max_population / 2 || rand(4) == 0) {
					str cmd = "Free Trade";
					if (set.CanAfford(cmd))
						strTech = cmd;
				}
	}
	if (rand(3) == 0)
		if (set.max_population >= 50)
			if (set.CanAfford("Slavery")) {
				bool sellSlaves = false;
				if (nAssUnderFire >= 20 && set.gold <= 1500)
					sellSlaves = true;
				else if (set.population >= set.max_population * 7 / 10)
					if (set.SupplyCount("BaseVillage") >= 1)
						sellSlaves = true;
				if (sellSlaves)
					if (!bFirstTechDone) {
						if (strTech == "") {
							strTech = strTechMarket[nRace];
							bForceResearch = true;
						}
					}
					else {
						str cmd = "Slavery";
						if (set.CanResearch(cmd)) {
							GetCmdCost(cmd, gold, food);
							set.SpentGoldOnTech(gold + food / 2);
							set.Research(cmd);
						}
					}
			}
}

//sell food (Iberia, Greece and Carthage); the high random value for Carthage is to reduce the chance of a sell/buy food command loop
if (nRace == Iberia || nRace == Greece || nRace == Carthage && rand(15) == 0) {
	int nSellFood;
	nSellFood = MAX(1000, AIVar(AIPlayer, AIV_SellFood));
	if (set.food >= nSellFood)
		if (rand(2) == 0)
			if (set.population >= set.max_population * 3 / 5)
				if (set.food >= nFoodReserve + 400) {
					str cmd = "HSellFood";
					if (nRace == Iberia)
						cmd = "Sell food";
					else if (nRace == Carthage)
						cmd = "CSellFood";
					if (nRace != Carthage && !bFirstTechDone) {
						strTech = strTechMarket[nRace];
						if (set.food >= nSellFood + 500)
							bForceResearch = true;
					}
					else {
						bld = set.FindResearchLab(cmd);
						if (bld.IsValid)
							if (bld.CmdCount(cmd) < 1) {
								GetCmdCost(cmd, gold, food);
								set.SpentGoldOnTech(gold + food / 2);
								bld.ExecCmd(cmd, ptDummy, objDummy, false);
							}
					}
				}
}

//call to arms (Iberia)
if (nRace == Iberia)
	if (nAssUnderFire > 0)
		if (set.CanAfford("Call to arms")) {
			str cmd = "Call to arms";
			bld = set.FindResearchLab(cmd);
			if (bld.IsValid)
				if (bld.CmdCount(cmd) < 1)
					if (!bFirstTechDone) {
						strTech = strTechMarket[nRace];
						bForceResearch = true;
					}
					else if (GetCmdCost(cmd, gold, food))
						if (!Intersect(ObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(AIPlayer, "Military")).IsEmpty()) {
							set.SpentGoldOnArmy(gold + food / 2);
							bld.ExecCmd(cmd, ptDummy, objDummy, false);
						}
		}

//organize tournament (Imperial Rome)
if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		if (strTech == "")
			if (set.max_population >= 50)
				if (set.population >= set.max_population * 4 / 5)
					if (IsResearched(set, "RGladiator Shows2")) {
						str cmd = "Organize tournament";
						if (set.CanAfford(cmd)) {
							int chance = 10;
							if (IsResearched(AIPlayer, "Flexibility"))
								chance = 100;
							else if (IsResearched(AIPlayer, "Standartization II"))
								chance = 50;
							else if (IsResearched(AIPlayer, "Standartization I"))
								chance = 25;
							if (rand(100) < chance) {
								GetCmdCost(cmd, gold, food);
								if (set.food - food >= MIN(1200, nFoodReserve / 2) || set.SupplyCount("BaseVillage") >= 3 || nAssUnderFire >= 10 || nMilUnits <= 30) {
									set.SpentGoldOnArmy(gold + food / 2);
									set.Research(cmd);
								}
							}
						}
					}

//gambler all-in (Britain)
if (nRace == Britain)
	if (strTech == "")
		if (bFirstTechDone)
			if (GetTime() - EnvReadInt(set, "LastAllIn") >= 180000) {
				str cmd = "Gambler's All-in";
				if (GetCmdCost(cmd, gold, food))
					if (set.gold - gold >= 1600 || set.CanAfford(cmd) && set.population <= set.max_population / 3) {
						set.SpentGoldOnTech(gold + food / 2);
						set.Research(cmd);
					}
			}

//supplies (Greece)
if (nRace == Greece)
	if (strTech == "")
		if (!IsResearched(AIPlayer, "Supplies"))
			if (nMilUnits >= 60 || set.food <= 400 || set.gold >= 3400 || rand(5) == 0) {
				if (!bFirstTechDone)
					strTech = strTechMarket[nRace];
				else
					strTech = "Supplies";
				if (nMilUnits >= 60 || set.food <= 400)
					bForceResearch = true;
			}

if (strTech != "") {
	if (bForceResearch) {
		if (EnvReadString(set, "ReserveFor" + (AIPlayer - 1)) != strTech) {
			int budget;
			budget = AIVar(AIPlayer, AIV_TechBudget);//save original value
			SetAIVar(AIPlayer, AIV_TechBudget, 100);
			set.StopReserving();
			EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			SetAIVar(AIPlayer, AIV_TechBudget, budget);//restore budget
			return;
		}
		EnvWriteInt(set, "ReserveCounter", 20);
	}
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}