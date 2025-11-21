//void, Settlement set

//called by ES_Stronghold, this script manages most tavern researches/commands along with some townhall/arena ones
//IMPORTANT: for the best results, keep the "first research - townhall - tribute - useful researches/commands - simple commands" order

int aiPlayer, nRace, nAssUnderFire;
str strTech;
bool bForceResearch = false, bEgyptGreeceSlaves = true;

aiPlayer = set.player;
nRace = set.GetCentralBuilding().race;

nAssUnderFire = EnvReadInt(set, "AssUnderFire");//set in ES_Stronghold

//first research
{
	StrArray strTechMarket;

	strTechMarket[Gaul] = "Free Beer";
	strTechMarket[RepublicanRome] = "Free Wine";
	strTechMarket[Carthage] = "Free Trade";
	strTechMarket[Iberia] = "Free Drinks";
	strTechMarket[ImperialRome] = "Trade Routes";//Greece
	strTechMarket[Britain] = "Gambling";
	strTechMarket[Egypt] = "Grain Trade";
	strTechMarket[Germany] = "Food sale";

	if (!IsResearched(set, strTechMarket[nRace])) {
		strTech = strTechMarket[nRace];
		if (nRace == RepublicanRome) {
			if (GetTime <= 180000)
				bForceResearch = true;//early exploration is extremely useful
		}
		else if (nRace == Britain) {
			if (GetTime <= 300000)
				bForceResearch = true;//early gambling is extremely useful in all cases
		}
		else if (nRace == Egypt) {
			if (set.food >= 2000)
				bForceResearch = true;//focus the research if storing a lot of food
		}
		else if (nRace == Germany) {
			bForceResearch = true;//get rid of the food requirement as soon as possible
			if (!set.CanAfford(strTech))
				if (!IsResearched(set, "Tribal fights"))
					strTech = "Tribal fights";//try to get food from other sources
		}
		else if (nRace == ImperialRome) {//Greece
			if (Villages(aiPlayer) >= 3)
				bForceResearch = true;//try to maximize food profit
		}
		else if (set.population <= set.max_population / 2)
			bForceResearch = true;//increase population as soon as possible if low (Gaul, Iberia and Carthage)
	}
}

//townhall - heal (Iberia and Egypt) and refreshment (Gaul and Britain)
if (rand(2) == 0) {
	Building b;
	if (nRace == Iberia)
		b = set.GetCentralBuilding();
	else if (nRace == Egypt)
		b = set.GetCentralBuilding();
	else if (nRace == Gaul) {
		if (nAssUnderFire >= 10)
			b = set.GetCentralBuilding();
	}
	else if (nRace == Britain)
		if (nAssUnderFire >= 10)
			b = set.GetCentralBuilding();
	if (b.IsValid) {
		ObjList olMilInRange;
		int i;
		i = b.sight * 3 / 2;
		olMilInRange = ObjsInRange(b, "Military", i).GetObjList();
		if (olMilInRange.count > 0) {
			ObjList olEnemy;
			olEnemy = olMilInRange.ObjEnemy(aiPlayer);
			if (olEnemy.count > 0) {
				olMilInRange.RemoveList(olEnemy);
				if (olMilInRange.count > 0) {
					int ownEval, allyEval, enemyEval;
					Eval(aiPlayer, b.pos, i, ownEval, allyEval, enemyEval);
					i = ownEval + allyEval;//this cannot be negative (reason for the specific -1 check below)
					if (i < enemyEval * 2)
						i = -1;
					else {
						i -= enemyEval;
						if (i >= -500)
							if (i <= 500)
								i = -1;
					}
					if (i == -1) {
						Unit u;
						int nHealth, nMaxHealth, nStamina, nMaxStamina;
						str cmd;
						for (i = 0; i < olMilInRange.count; i += 1) {
							u = olMilInRange[i].AsUnit();
							if (u.IsValid)
								if (u.IsAlive) {
									nHealth += u.health;
									nMaxHealth += u.maxhealth;
									nStamina += u.stamina;
									nMaxStamina += u.maxstamina;
								}
						}
						if (nRace == Iberia) {
							if (nHealth <= nMaxHealth * 2 / 3)
								cmd = "heal";
						}
						else if (nRace == Egypt) {
							if (nHealth <= nMaxHealth / 2)//with Religious Feast and other bonuses/skills, healing for Egypt is much easier than for Iberia
								cmd = "heal";
						}
						else if (nRace == Britain) {
							if (nStamina <= nMaxStamina / 2)
								cmd = "refreshment";
						}
						else if (nRace == Gaul)
							if (nStamina <= nMaxStamina / 3)//Gaul units generally benefit less from stamina than Britain ones
								cmd = "refreshment";
						if (cmd != "")
							if (set.CanResearch(cmd))
								if (set.CanAfford(cmd)) {
									int gold, food;
									if (GetCmdCost(cmd, gold, food)) {
										set.SpentGoldOnTech(gold + food / 2);
										set.Research(cmd);
									}
								}
					}
				}
			}
		}
	}
}

//townhall - hire sentries (Greece)
if (nRace == ImperialRome)
	if (nAssUnderFire >= 10)
		if (rand(2) == 0)
			if (set.gold >= 1600)
				if (GetTime() >= 300000)//avoid hiring sentries as soon as the game starts
					if (set.GetNumSentries() <= set.GetMaxSentries() / 3)//total max = InitialStrongholdSentries + 1 per wall + 4 per gate (usually 50-52)
						if (set.CanResearch("hire_sentries"))
							if (set.CanAfford("hire_sentries")) {
								int gold, food;
								if (GetCmdCost("hire_sentries", gold, food))
									if (!Intersect(VisibleObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(aiPlayer, "Military")).IsEmpty) {
										set.SpentGoldOnTech(gold + food / 2);
										set.Research("hire_sentries");
									}
							}

//tribute
if (strTech == "")
	if (nAssUnderFire <= 0)
		if (AIVar(aiPlayer, AIV_Tribute) != 0)
			if (EnvReadString(aiPlayer, "Tribute") == "") {
				int nAllOutposts;
				nAllOutposts = Outposts(0);
				if (nAllOutposts > 1) {//tribute is useful only if there are at least 2 outposts (for positive profit)
					int nOwnedOutposts;
					nOwnedOutposts = Outposts(aiPlayer);
					if (rand(100) < nOwnedOutposts * 100 / nAllOutposts) {//the chance of wanting tribute equals the percentage of owned outposts
						Building b;
						str cmd;
						if (nRace == ImperialRome)//Greece
							cmd = "HTribute";
						else
							cmd = GetRaceStrPref(nRace) + "Tribute";
						b = set.FindResearchLab(cmd);
						if (b.IsValid)
							if (!b.IsBroken) {
								str times, values;
								int time, i;
								times = GetConstStr("TributeTimes");
								values = GetConstStr("TributeGold");
								while (times != "") {//this makes the AI want tribute only when the maximum time range has been reached (for maximum profit)
									time = Str2Int(ParseStr(times, times)) * 60000;
									i = Str2Int(ParseStr(values, values));
								}
								if (GetTime() >= time - GetConst("TributeDuration") * 1000) {//the subtraction allows the AI to want tribute in an even more optimal way
									int gold, food;
									if (GetCmdCost(cmd, gold, food)) {
										i = i * nOwnedOutposts - gold;//the potential profit determines the chance of wanting tribute
										if (i > 0) {
											if (i <= 2000)
												i = 18;
											else if (i <= 6000)
												i = 12;
											else if (i <= 10000)
												i = 6;
											else
												i = 1;
											if (rand(i) == 0) {//research tribute as soon as possible
												strTech = cmd;
												bForceResearch = true;
												if (set.CanResearch(cmd))
													if (set.CanAfford(cmd)) {
														set.SpentGoldOnTech(gold + food / 2);
														set.Research(cmd);
														strTech = "";
														bForceResearch = false;
													}
											}
										}
									}
								}
							}
						if (strTech == "")
							if (EnvReadString(set, "ReserveFor" + (aiPlayer - 1)) == cmd) {
								set.StopReserving();
								EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
							}
					}
				}
				else
					SetAIVar(aiPlayer, AIV_Tribute, 0);//this reduces the amount of checks done if there are not enough outposts
			}

//useful researches/commands - investment and organize tournament (Rome and Imperial Rome)
if (nRace == RepublicanRome) {
	if (strTech == "")
		if (nAssUnderFire <= 0)
			if (rand(3) == 0)
				if (GetTime() >= 300000) {
					Building b;
					b = set.FindResearchLab("investR");
					if (b.IsValid)
						if (!b.IsBroken)
							if (b.CmdCount("investR") < 1) {
								int gold, food;
								if (GetCmdCost("investR", gold, food))
									if (set.CanAfford("investR")) {
										point ptDummy;
										Obj objDummy;
										if (EnvReadString(set, "ReserveFor" + (aiPlayer - 1)) == "investR") {
											set.StopReserving();
											EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
										}
										set.SpentGoldOnTech(gold + food / 2);
										b.ExecCmd("investR", ptDummy, objDummy, false);
									}
									else if (set.gold >= gold - 800) {
										strTech = "investR";
										bForceResearch = true;
									}
							}
				}
	if (strTech == "")
		if (IsResearched(set, "ChooseImperialRome"))
			if (set.max_population >= 50)
				if (set.population >= set.max_population * 4 / 5)
					if (IsResearched(set, "RGladiator Shows2"))
						if (set.CanResearch("Organize tournament"))
							if (set.CanAfford("Organize tournament")) {
								int gold, food;
								if (GetCmdCost("Organize tournament", gold, food)) {
									int i;
									if (MilUnits(aiPlayer) <= 30)
										i = 15;
									else if (nAssUnderFire >= 10)
										i = 10;
									else if (set.SupplyCount("BaseVillage") >= 3)
										i = 5;
									if (i > 0) {
										if (IsResearched(aiPlayer, "Flexibility"))
											i += 65;
										else if (IsResearched(aiPlayer, "Standartization II"))
											i += 35;
										else if (IsResearched(aiPlayer, "Standartization I"))
											i += 5;
										if (IsResearched(set, "God's Gift"))
											i += 20;
										if (rand(100) < i) {
											set.SpentGoldOnArmy(gold + food / 2);
											set.Research("Organize tournament");
										}
									}
								}
							}
}

//useful researches/commands - religious feast (Egypt, Germany and Greece)
if (strTech == "")
	if (rand(3) == 0)
		if (MilUnits(aiPlayer) >= 20) {
			str cmd;
			if (nRace == Egypt) {
				if (set.food >= 2000)
					cmd = "Religious Feast";
			}
			else if (nRace == Germany) {
				if (set.gold >= 2000)
					cmd = "TReligiousFeast";
			}
			else if (nRace == ImperialRome)
				if (set.gold >= 1500)
					if (set.food >= 1500)
						cmd = "HReligiousFeast";
			if (cmd != "") {
				if (!IsResearched(set, cmd))
					if (!IsResearching(set, cmd)) {
						Building b;
						b = set.FindResearchLab(cmd);
						if (b.IsValid)
							if (!b.IsBroken)
								strTech = cmd;
					}
				}
		}

//useful researches/commands - food tax (Germany and Gaul)
if (strTech == "") {
	str cmd;
	if (nRace == Gaul)
		cmd = "Food Tax";
	else if (nRace == Germany)
		cmd = "TFoodTax";
	if (cmd != "")
		if (!IsResearched(set, cmd))
			if (!IsResearching(set, cmd)) {
				Building b;
				b = set.FindResearchLab(cmd);
				if (b.IsValid)
					if (!b.IsBroken) {
						strTech = cmd;
						if (nRace == Germany)
							bForceResearch = true;//food tax is extremely important for Germany
					}
			}
}

//useful researches/commands - gambler's all-in (Britain)
if (nRace == Britain)
	if (strTech == "")
		if (GetTime() - EnvReadInt(set, "LastAllIn") >= 180000)
			if (!IsResearching(set, "Gambler's All-in")) {
				Building b;
				b = set.FindResearchLab("Gambler's All-in");
				if (b.IsValid)
					if (!b.IsBroken) {
						int gold, food;
						if (GetCmdCost("Gambler's All-in", gold, food))
							if (set.gold - gold >= 1600)
								strTech = "Gambler's All-in";
							else if (set.population <= set.max_population / 3) {
								strTech = "Gambler's All-in";
								if (set.food <= 1000)
									bForceResearch = true;//a very good alternative to many add population commands
							}
					}
			}

//useful researches/commands - supplies and stop storing food (Greece) - the latter is just to reduce the amount of possible exploits by human players
if (nRace == ImperialRome) {
	if (strTech == "")
		if (!IsResearched(aiPlayer, "Supplies"))
			if (!IsResearching(aiPlayer, "Supplies"))
				if (set.food <= 400) {
					strTech = "Supplies";
					bForceResearch = true;
				}
				else if (MilUnits(aiPlayer) >= 60) {
					strTech = "Supplies";
					bForceResearch = true;
				}
				else if (rand(5) == 0)
					strTech = "Supplies";
	if (EnvReadInt(set, "IsStoring") == 1)
		if (EnvReadInt(set, "FoodStorage") >= 1000)//it takes about 200 seconds to store 1000 food (up to 10 every 2 seconds)
			if (set.CanResearch("stopStoringFood"))
				set.Research("stopStoringFood");
}

//useful researches/commands - foreign mercenaries and slavery (Carthage)
if (nRace == Carthage)
	if (strTech == "") {
		if (IsResearched(aiPlayer, "Mercenary pact"))
			if (IsResearched(aiPlayer, "Mercenary heal")) {
				Building b;
				b = set.FindResearchLab("Hire foreign mercenaries");
				if (b.IsValid)
					if (!b.IsBroken)
						if (b.CmdCount("Hire foreign mercenaries") < 1) {
							int gold, food;
							if (GetCmdCost("Hire foreign mercenaries", gold, food))
								if (set.CanAfford("Hire foreign mercenaries")) {
									point ptDummy;
									Obj objDummy;
									if (EnvReadString(set, "ReserveFor" + (aiPlayer - 1)) == "Hire foreign mercenaries") {
										set.StopReserving();
										EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
									}
									set.SpentGoldOnArmy(gold + food / 2);
									b.ExecCmd("Hire foreign mercenaries", ptDummy, objDummy, false);
								}
								else if (set.gold >= gold - 1200)
									if (set.food >= food + 600) {
										strTech = "Hire foreign mercenaries";
										bForceResearch = true;
									}
						}
			}
		if (strTech == "")
			if (rand(3) == 0) {
				str cmd;
				if (nAssUnderFire >= 20) {
					if (set.gold <= 1500)
						cmd = "Slavery";
				}
				else if (rand(2) == 0)
					if (set.population >= set.max_population + 10) {
						if (set.SupplyCount("BaseVillage") >= 1)
							cmd = "Slavery";
					}
					else if (set.population >= set.max_population * 9 / 10)
						if (set.SupplyCount("BaseVillage") >= 3)
							cmd = "Slavery";
				if (cmd != "")
					if (set.CanResearch(cmd))
						if (set.CanAfford(cmd)) {
							int gold, food;
							if (GetCmdCost(cmd, gold, food)) {
								set.SpentGoldOnTech(gold + food / 2);
								set.Research(cmd);
							}
						}
			}
	}

//useful researches/commands - housing 1-2 and call to arms (Iberia)
if (nRace == Iberia) {
	if (strTech == "")
		if (set.population >= set.max_population * 4 / 5)
			if (!IsResearched(set, "More Housing"))
				if (!IsResearching(set, "More Housing"))
					if (!IsResearching(set, "Housing")) {
						Building b;
						b = set.FindResearchLab("More Housing");
						if (b.IsValid)
							if (!b.IsBroken) {
								strTech = "More Housing";
								if (set.population >= set.max_population)
									bForceResearch = true;
							}
					}
	//IMPORTANT: this part must stay after the other Iberian researches to override strTech (see final inner instruction below)
	if (nAssUnderFire > 0)
		if (IsResearched(set, "Free Drinks"))
			if (set.CanAfford("Call to arms")) {
				Building b;
				b = set.FindResearchLab("Call to arms");
				if (b.IsValid)
					if (!b.IsBroken)
						if (b.CmdCount("Call to arms") < 1) {
							int gold, food;
							if (GetCmdCost("Call to arms", gold, food))
								if (!Intersect(VisibleObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(aiPlayer, "Military")).IsEmpty) {
									point ptDummy;
									Obj objDummy;
									set.SpentGoldOnArmy(gold + food / 2);
									b.ExecCmd("Call to arms", ptDummy, objDummy, false);
									strTech = "";//this is to avoid researching something and delaying the command
								}
						}
			}
}

//useful researches/commands - hecatomb and slavery investment (Egypt) | IMPORTANT: this part must stay before "buy slaves"
if (nRace == Egypt)
	if (strTech == "") {
		if (set.max_population - set.population >= 50)
			if (set.CanAfford("Hecatomb")) {
				Building b;
				b = set.FindResearchLab("Hecatomb");
				if (b.IsValid)
					if (!b.IsBroken)
						if (b.CmdCount("Hecatomb") < 1) {
							int gold, food;
							if (GetCmdCost("Hecatomb", gold, food)) {
								point ptDummy;
								Obj objDummy;
								set.SpentGoldOnTech(gold + food / 2);
								b.ExecCmd("Hecatomb", ptDummy, objDummy, false);
								bEgyptGreeceSlaves = false;
							}
						}
			}
		if (strTech == "")
			if (bEgyptGreeceSlaves)
				if (rand(2) == 0)
					if (set.gold >= 2500)
						if (set.population <= set.max_population * 2 / 3)
							if (set.SupplyCount("BaseVillage") >= 3)
								strTech = "Slavery investment";
	}

//simple commands - buy slaves (Greece and Egypt) | IMPORTANT: this part must stay between "hecatomb and slavery investment" and "add population"
if (rand(5) == 0) {
	str cmd;
	if (nRace == ImperialRome) {
		if (strTech == "")
			cmd = "HBuySlaves";
	}
	else if (nRace == Egypt) {
		if (bEgyptGreeceSlaves)
			cmd = "BuySlaves";
	}
	if (cmd != "")
		if (set.population <= set.max_population - 15)
			if (set.CanAfford(cmd)) {
				Building b;
				b = set.FindResearchLab(cmd);
				if (b.IsValid)
					if (!b.IsBroken)
						if (b.CmdCount(cmd) < 1) {
							int gold, food;
							if (GetCmdCost(cmd, gold, food)) {
								point ptDummy;
								Obj objDummy;
								set.SpentGoldOnTech(gold + food / 2);
								b.ExecCmd(cmd, ptDummy, objDummy, false);
								bEgyptGreeceSlaves = false;
							}
						}
			}
}

//simple commands - add population (all except Egypt) | IMPORTANT: this part must stay between "buy slaves" and "sell food"
if (rand(2) == 0)
	if (nRace != Egypt) {
		str cmd;
		if (nRace == ImperialRome) {//Greece
			if (bEgyptGreeceSlaves)
				cmd = "HAddPop";
		}
		else if (nRace == Carthage) {
			if (rand(2) == 0)//the random is because the Carthaginian version is expensive
				cmd = GetRaceStrPref(nRace) + "AddPop";
		}
		else
			cmd = GetRaceStrPref(nRace) + "AddPop";
		if (cmd != "")
			if (set.CanAfford(cmd)) {
				Building b;
				b = set.FindResearchLab(cmd);
				if (b.IsValid)
					if (!b.IsBroken) {
						int i;
						i = b.CmdCount(cmd);
						if (i < 2)
							if (set.population + i * 10 <= set.max_population - 5) {
								int gold, food;
								if (GetCmdCost(cmd, gold, food))
									if (set.food - food >= MIN(1200, EnvReadInt(set, "nFoodReserve") / 2)) {
										point ptDummy;
										Obj objDummy;
										set.SpentGoldOnTech(gold + food / 2);
										b.ExecCmd(cmd, ptDummy, objDummy, false);
									}
							}
					}
			}
	}

//simple commands - sell food (Iberia, Greece and Carthage); the high random for Carthage is to reduce the chance of a "sell/buy food" command loop
if (rand(2) == 0) {
	str cmd;
	if (nRace == Iberia) {
		if (strTech == "")
			cmd = "Sell food";
	}
	else if (nRace == ImperialRome) {
		if (strTech == "")
			cmd = "HSellFood";
	}
	else if (nRace == Carthage)
		if (rand(15) == 0)
			cmd = "CSellFood";
	if (cmd != "")
		if (set.population >= set.max_population * 3 / 5)
			if (set.food >= EnvReadInt(set, "nFoodReserve") + 400)
				if (set.food >= MAX(1000, AIVar(aiPlayer, AIV_SellFood))) {
					Building b;
					b = set.FindResearchLab(cmd);
					if (b.IsValid)
						if (!b.IsBroken)
							if (b.CmdCount(cmd) < 1) {
								int gold, food;
								if (GetCmdCost(cmd, gold, food)) {
									point ptDummy;
									Obj objDummy;
									set.SpentGoldOnTech(gold + food / 2);
									b.ExecCmd(cmd, ptDummy, objDummy, false);
								}
							}
				}
}

//simple commands - buy food; the random for Carthage is to reduce the chance of a "buy/sell food" command loop
if (set.food < 2500) {
	str cmd;
	if (nRace == Germany)
		cmd = "buyfoodforgold";
	else if (nRace == Carthage) {
		if (rand(2) == 0)
			cmd = "buyfoodforgold";
	}
	else if (nRace == RepublicanRome)
		if (IsResearched(set, "ChooseRepublicanRome"))
			cmd = "buyfoodforgold";
		else if (IsResearched(set, "ChoosePunicRome"))
			cmd = "buyfoodforgold";
	if (cmd != "")
		if (set.CanAfford(cmd)) {
			int gold, food;
			if (GetCmdCost(cmd, gold, food)) {
				Building b;
				if (set.food < 300)
					b = set.FindResearchLab(cmd);
				else if (strTech == "")
					if (rand(4) == 0)
						b = set.FindResearchLab(cmd);
					else if (nRace == Germany)
						if (rand(2) == 0)
							if (set.gold >= set.food * 3)
								b = set.FindResearchLab(cmd);
				if (b.IsValid)
					if (!b.IsBroken)
						if (b.CmdCount(cmd) < 2) {
							point ptDummy;
							Obj objDummy;
							set.SpentGoldOnTech(gold + food / 2);
							b.ExecCmd(cmd, ptDummy, objDummy, false);
						}
			}
		}
}

if (strTech != "") {
	if (bForceResearch) {
		EnvWriteInt(set, "ResearchTechTime", GetTime());
		if (EnvReadString(set, "ReserveFor" + (aiPlayer - 1)) != strTech) {
			int budget;
			budget = AIVar(aiPlayer, AIV_TechBudget);//save original value
			SetAIVar(aiPlayer, AIV_TechBudget, 100);
			set.StopReserving();
			EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			SetAIVar(aiPlayer, AIV_TechBudget, budget);//restore value
			return;
		}
		EnvWriteInt(set, "ReserveCounter", 20);
	}
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}