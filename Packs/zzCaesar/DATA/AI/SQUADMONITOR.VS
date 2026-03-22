//void

Squad sq;
Unit sqLeader;
Hero sqLeaderHero;
GAIKA sqGkIn, sqGkAiDest;
Settlement setGkIn, setGkAiDest;
Building setGkInCentralBuilding;
point sqPos, setGkAiDestCentralBuildingPos;
int aiPlayer, nSleepSquadMonitor, nMagePerc, nSqState, min, own, ally, enemy, enemy_hidden, i;
bool bUseRuins, bSynchApproach, bCoward, bGoAround, bTakeItems;

Sleep(rand(1001) + 500);

aiPlayer = AIGetPlayer();
nSleepSquadMonitor = AIVar(aiPlayer, AIV_Sleep_SquadMonitor);
nMagePerc = AIVar(aiPlayer, AIV_MageAttach);

bUseRuins = AIVar(aiPlayer, AIV_UseRuins) != 0;
bSynchApproach = AIVar(aiPlayer, AIV_SynchApproach) != 0;
bCoward = AIVar(aiPlayer, AIV_Coward) != 0;
bGoAround = AIVar(aiPlayer, AIV_GoAround) != 0;
bTakeItems = AIVar(aiPlayer, AIV_TakeItems) != 0;

while (1) {
	i = GetTime() / 60000;
	if (i >= 30)
		min = MIN(41, MAX(41, MilUnits(aiPlayer) / 4));
	else if (i >= 20)
		min = MIN(41, MAX(31, MilUnits(aiPlayer) / 4));
	else if (i >= 10)
		min = MIN(41, MAX(20, MilUnits(aiPlayer) / 4));
	else
		min = MIN(41, MAX(15, MilUnits(aiPlayer) / 4));

	for (i = NumSquads(aiPlayer) - 1; i >= 1; i -= 1) {
		sq = GetSquad(aiPlayer, i);
		if (sq.Size > 0) {
			sqLeader = sq.Leader;
			if (sqLeader.IsValid)
				if (!sqLeader.AsShip().IsValid)//ships are managed internally by the game
					if (!sqLeader.GetFlags(UNITFLAG_NOAI))
						if (!sq.TestFlags(SF_NOAI)) {
							sqGkIn = sq.GAIKAIn;
							if (IsWaterLsa(sqGkIn.LSA))//units in ships are not monitored
								if (sq.InHolder) {
									Sleep(5);
									continue;
								}

							nSqState = sq.State;
							sqPos = sq.pos;

							setGkIn = sqGkIn.settlement;
							if (setGkIn.IsValid)
								setGkInCentralBuilding = setGkIn.GetCentralBuilding();

							sqGkAiDest = sq.AIDest;
							setGkAiDest = sqGkAiDest.settlement;
							if (setGkAiDest.IsValid)
								setGkAiDestCentralBuildingPos = setGkAiDest.GetCentralBuilding().pos;

							if (nSqState == SS_Approach || nSqState == SS_IDLE)
								if (setGkIn.IsValid) {
									if (setGkIn.IsIndependent) {//approach to capture a settlement when moving around it
										bool bCheck = false;
										if (setGkIn.IsVillage)
											bCheck = true;
										else if (setGkIn.IsShipyard)
											bCheck = true;
										else if (setGkIn.IsOutpost)
											if (!setGkIn.IsIndependentGuarded)
												bCheck = true;
										if (bCheck) {
											point ptBld;
											int nDist, nSight;
											sqLeader.SetVisible(true);
											sqLeader.SetLastAttackTime();
											ptBld = setGkInCentralBuilding.pos;
											nDist = sqLeader.DistTo(ptBld);
											nSight = setGkInCentralBuilding.sight * 2 / 3;
											if (nDist > nSight) {
												sq.Units.SetCommand("advance", ptBld + (sqLeader.pos - ptBld) * nSight / nDist);
												if (sqGkAiDest > 0)
													sq.Units.AddCommand(false, "advance", sqGkAiDest.Center);
												Sleep(100);
												continue;
											}
										}
									}
									if (sqLeader.command == "idle" || sqLeader.command == "stand_position")//gather staying army together
										if (sqGkIn != sqGkAiDest)
											if (setGkAiDest.IsValid)
												if (setGkAiDest.IsEnemy(aiPlayer)) {
													bool bCheck = false;
													if (setGkIn.IsOutpost)
														bCheck = true;
													else if (setGkIn.IsVillage)
														bCheck = true;
													else if (setGkIn.IsShipyard)
														bCheck = true;
													if (bCheck)
														if (setGkAiDestCentralBuildingPos.Dist(sqPos) < 2000) {
															sqGkAiDest.Eval(AI_ALL, aiPlayer, own, ally, enemy, enemy_hidden);
															if (own + ally + sq.Eval > enemy * 2) {
																sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGkAiDestCentralBuildingPos);
																Sleep(100);
																continue;
															}
														}
												}
								}

							if (nSqState != SS_IDLE)
								if (nSqState != SS_ApproachWait)
									if (nSqState != SS_Siege)
										if (nSqState != SS_Catapult)
											if (!sqLeader.InHolder)
												if (sqLeader.command == "idle" || sqLeader.command == "stand_position") {
													sq.DelOrder();
													sq.SetState(SS_IDLE);
												}

							if (nSqState == SS_KillAll) {
								if (sqLeader.command == "ai_killall" || sqLeader.command == "idle" || sqLeader.command == "stand_position") {
									if (setGkAiDest.IsValid)
										if (!sqLeader.IsVisible) {
											sqLeader.SetVisible(true);
											sqLeader.SetLastAttackTime();
										}
									if (sq.StateTime > 60000)
										if (setGkAiDest.IsValid) {
											if (setGkAiDestCentralBuildingPos.Dist(sqPos) > 500)
												sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGkAiDestCentralBuildingPos);
											else if (setGkIn.IsValid)
												if (setGkIn.IsAlly(aiPlayer))
													sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGkInCentralBuilding);
										}
										else
											sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
								}
							}
							else if (nSqState == SS_Catapult) {
								if (!sqLeader.InHolder)
									if (sqLeader.command != "build_catapult")
										sq.SetState(SS_IDLE);
							}
							else if (nSqState == SS_IDLE)
								if (sqLeader.command == "idle" || sqLeader.command == "stand_position")
									if (!sq.InHolder)
										if (sqGkIn == sqGkAiDest)
											if (sqGkIn.StratRunning(aiPlayer) == GS_EnterSettlement)
												if (!sq.TestFlags(SF_PEACEFUL))
													if (!sq.TestFlags(SF_NOAI))
														if (setGkIn.IsValid)
															sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGkInCentralBuilding);

							sqLeaderHero = sqLeader.AsHero();

							if (sqLeader.command == "idle" || sqLeader.command == "stand_position") {
								if (nSqState == SS_IDLE || nSqState == SS_Enter)
									if (sqGkAiDest > 0 && sqGkIn != sqGkAiDest) {
										sq.SendTo(sqGkAiDest, 1);
										Sleep(100);
										continue;
									}
									else if (sq.Size <= 10)//send units from tents and other small armies at home
										if (sq.Eval < 5000)
											if (sqGkIn.StratRunning(aiPlayer) == GS_NONE || sqGkIn.StratRunning(aiPlayer) == GS_EnterSettlement)
												if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid().IsValid) {
													Settlement s;
													s = sqLeader.GetHolderSett();
													if (s.IsTTent) {
														if (rand(15) == 0)
															if (s.UnitsCount >= 8) {
																s = NearestStronghold(sqPos, sq.Player);
																if (s.IsValid) {
																	SquadList SL;
																	sqGkIn.GetSquads(SL, AI_STAYING, aiPlayer);
																	SL.Lock();
																	for (; !SL.EOL; SL.Next())
																		if (SL.Cur.Leader.GetHolderSett().IsTTent)
																			sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
																	SL.Unlock();
																	Sleep(100);
																	continue;
																}
															}
													}
													else if (!sq.InHolder && GetTime() > 900000) {
														s = NearestStronghold(sqPos, sq.Player);
														if (s.IsValid) {
															sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
															Sleep(100);
															continue;
														}
													}
													else if (!sqLeaderHero.IsValid)
														if (!sqLeader.HasFreedom)
															if (!s.IsStronghold) {
																s = NearestStronghold(sqPos, sq.Player);
																if (s.IsValid) {
																	sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
																	Sleep(100);
																	continue;
																}
															}
												}
								if (nSqState == SS_IDLE || nSqState == SS_Wait)//retreat idle units from tower/sentry range
									if (sq.LastFightTime > GetTime() - 3000) {
										Obj lastAttacker;
										lastAttacker = sq.GetLastAttacker();
										if (lastAttacker.IsValid)
											if (lastAttacker.IsSentry) {
												point pt;
												pt = sqPos - sq.GetLastAttacker().pos;
												pt.SetLen(125);
												sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sqPos + pt);
											}
											else if (lastAttacker.AsBuilding().IsValid) {
												point pt;
												pt = sqPos - sq.GetLastAttacker().pos;
												pt.SetLen(150);
												sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sqPos + pt);
											}
									}
							}

							if (bUseRuins)//use ruins
								if (rand(3) == 0)
									if (sqLeaderHero.IsValid)
										if (sqLeaderHero.free_item_slots > 0)
											if (sq.InHolder)
												if (setGkIn.IsValid)
													if (setGkIn.IsStronghold) {
														Obj ruins;
														if (nSqState == SS_Ruins)
															sq.SetState(SS_IDLE);
														ruins = FindRuins(sqPos, 8000, sqLeader.inherentlevel);
														if (ruins.IsValid) {
															sqLeaderHero.DetachArmy();
															sq.SetCmd(SS_Ruins, 0, SF_ADVCHOOSER, "enter", ruins);
															sqLeader.AddCommand(false, "enter", setGkInCentralBuilding);
															Sleep(100);
															continue;
														}
													}

							if (sqLeader.items_count > 0)//use items
								if (sqLeaderHero.IsValid) {
									if (sqLeader.HasItem("Poison Mushroom"))
										if (sqLeader.HasItem("Healing herbs"))
											sqLeader.UseItem("Poison Mushroom");
										else if (sqLeader.HasItem("Ash of druid heart"))
											sqLeader.UseItem("Poison Mushroom");
										else if (sqLeader.HasItem("Ring of Power"))
											sqLeader.UseItem("Poison Mushroom");
										else if (sqLeader.HasItem("Elephant Tusk"))
											sqLeader.UseItem("Poison Mushroom");
										else {
											Item water_bowl, water_bag;
											int amount_bowl, amount_bag;

											water_bowl = sqLeader.FindItem("Healing water");
											if (water_bowl.IsValid)
												amount_bowl = water_bowl.use_count;

											water_bag = sqLeader.FindItem("Bag of healing water");
											if (water_bag.IsValid)
												amount_bag = water_bag.use_count;

											if (sqLeader.maxhealth / 2 <= MAX(amount_bowl, amount_bag))//use if possible to heal at least 50% max health with water
												sqLeader.UseItem("Poison Mushroom");
										}

									if (sqLeader.HasItem("Healing herbs"))
										if (sqLeader.health < sqLeader.maxhealth / 4)
											sqLeader.UseItem("Healing herbs");

									if (sqLeader.HasItem("Healing water"))
										if (sqLeader.health < sqLeader.maxhealth / 3)
											sqLeader.UseItem("Healing water");
										else if (sq.health < sq.maxhealth / 2)
											sqLeader.UseItem("Healing water");
										else if (sq.health <= sq.maxhealth - 1000)
											sqLeader.UseItem("Healing water");

									if (sqLeader.HasItem("Bag of healing water"))
										if (sqLeader.health < sqLeader.maxhealth * 2 / 5)
											sqLeader.UseItem("Bag of healing water");
										else if (sq.health < sq.maxhealth * 3 / 5)
											sqLeader.UseItem("Bag of healing water");
										else if (sq.health <= sq.maxhealth - 800)
											sqLeader.UseItem("Bag of healing water");

									if (sqLeader.HasItem("Ash of druid heart"))
										if (sqLeader.health < sqLeader.maxhealth / 4)
											sqLeader.UseItem("Ash of druid heart");
										else if (sq.health < sq.maxhealth / 3)
											sqLeader.UseItem("Ash of druid heart");

									if (sqLeader.HasItem("Rye spikes"))
										if (sq.food < sq.Size * 3 / 2)
											sqLeader.UseItem("Rye spikes");

									if (rand(3) == 0) {//avoid spamming items
										str item;
										if (sqLeader.HasItem("Horn of victory"))
											item = "Horn of victory";
										else if (sqLeader.HasItem("Finger of death"))
											item = "Finger of death";
										else if (sqLeader.HasItem("Skull of Pain")) {
											if (sqLeader.health >= sqLeader.maxhealth * 3 / 4)
												item = "Skull of Pain";
										}
										else if (sqLeader.HasItem("Battle Drums of Rage"))
											if (nSqState == SS_KillAll)
												item = "Battle Drums of Rage";
											else if (sqLeader.command == "ai_killall")
												item = "Battle Drums of Rage";
											else if (sqLeader.command == "engage")
												item = "Battle Drums of Rage";
											else if (sqLeader.command == "attack")
												item = "Battle Drums of Rage";
										if (item != "") {
											sqGkIn.Eval(AI_ALL, aiPlayer, own, ally, enemy, enemy_hidden);
											if (own + ally < sqGkIn.MinNeed(aiPlayer, own, ally, enemy) * 5 / 4)//difficult situation
												sqLeader.UseItem(item);
										}
									}
								}

							if (nSqState == SS_Flee)//stop fleeing to heal and check if stopping fleeing is worth
								if (sq.InHolder)
									sq.SetState(SS_IDLE);
								else {
									bool bCheck = false;

									if (sqLeaderHero.IsValid)
										if (sq.food > 100)
											if (!sqLeader.BestTargetInSquadSight.IsValid) {
												int healers;
												healers = sq.Count("GDruid");
												if (healers < 5) {
													healers += sq.Count("RPriest");
													if (healers < 5)
														healers += sq.Count("HPriest");
												}
												if (healers >= 5)
													sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sqLeader.pos);
											}

									if (sqLeaderHero.IsValid)
										if (sqLeader.health < sqLeader.maxhealth / 3)
											sqLeaderHero.DetachArmy();
									if (sqPos.Dist(sqGkAiDest.Center) <= 1500)
										bCheck = true;
									else if (!sqLeader.BestTargetInSquadSight.IsValid)
										bCheck = true;
									if (bCheck)
										if (sqGkIn == sqGkAiDest) {
											if (setGkIn.IsValid)
												if (!setGkIn.IsAlly(aiPlayer))
													sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
												else if (setGkIn.IsFull)
													sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
												else
													sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGkInCentralBuilding);
											else
												sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
											Sleep(100);
											continue;
										}
										else if (bCoward)
											if (sq.Size >= min - 10)
												if (sqLeader.health >= sqLeader.maxhealth / 2)
													if (sq.health >= sq.maxhealth / 2) {
														sq.SetState(SS_Approach);
														Sleep(100);
														continue;
													}
								}
							else {
								if (sq.Eval >= 3000) {//check feeding
									int needed, food;
									needed = sq.Size * (sqPos.Dist(sqGkAiDest.Center) + 200) / 700;//add 200 to help feeding already hungry squads
									if (bSynchApproach)
										needed = needed * 4 / 3;
									food = sq.food + sq.FoodComing;
									if (food + 100 < needed)//do not ask for less than 100 food
										sq.SendFoodWagon(needed - food, 3000);
								}
								if (nSqState != SS_Ruins)//flee behaviour and collection of items
									if (sqLeaderHero.IsValid) {
										bool bHeroHurt = false, bDetachArmy = false;
										int nFlee;//2-hero_dying, 4-army_dying, 8-losing

										if (sqLeader.health < sqLeader.maxhealth / 2)
											if (sqLeader.BestTargetInSquadSight.IsValid) {
												bHeroHurt = true;
												nFlee += 2;
												if (sqLeader.health < sqLeader.maxhealth / 3)
													bDetachArmy = true;
											}

										if (bCoward) {
											bool bFleeCheck = false;
											if (sq.health < sq.maxhealth / 2)
												if (!sqLeaderHero.SkillInEffect(hsFrenzy))//avoid fleeing if the skill has just been activated
													nFlee += 4;
											if (sqGkAiDest == sqGkIn)
												bFleeCheck = true;
											if (!bFleeCheck)
												if (setGkIn.IsValid)
													if (setGkIn.IsTTent)
														if (setGkIn.IsEnemy(aiPlayer))
															if (sqLeader.command == "engage")
																bFleeCheck = true;
											if (bFleeCheck) {
												sqGkIn.Eval(AI_ALL, aiPlayer, own, ally, enemy, enemy_hidden);
												if (own + ally < sqGkIn.MinNeed(aiPlayer, own, ally, enemy) / 2)
													nFlee += 8;
											}
										}

										if (!bHeroHurt)
											if (nFlee != 0)
												if (nFlee != 8) {
													int nMinNeed;
													sqGkAiDest.Eval(AI_COMING + AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
													nMinNeed = sqGkIn.MinNeed(aiPlayer, own, ally, enemy);
													if (own + ally >= nMinNeed)
														if (sq.Size > 6) {
															int n;
															n = own + ally - sq.Eval;
															if (n > 0)
																if (n < nMinNeed)//do not flee if allies cannot win
																	nFlee = 0;
														}
												}

										if (nFlee != 0) {
											sqGkIn.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
											enemy += sqGkIn.Eval(AI_LEAVING, aiPlayer, AI_ENEMY);
											if (enemy <= 0)
												if (setGkIn.IsValid)
													if (setGkIn.IsEnemy(aiPlayer))
														if (setGkIn.CanBeCaptured)
															nFlee = 0;

											if (nFlee != 0) {
												GAIKA gFlee;

												gFlee = NearestHospital(sq);
												if (gFlee == 0)	{
													int nHomeGaikaID;
													nHomeGaikaID = EnvReadInt(aiPlayer, "HomeGaika");
													if (nHomeGaikaID > 0)
														gFlee = GetGAIKA(nHomeGaikaID);
												}
												if (nFlee == 8)
													if (sqGkAiDest != sqGkIn) {//ambushed but otherwise ok, decide where to flee
														int distGoal;
														if (sq.DestGAIKA == sqGkAiDest) {
															bool bCheck = false;
															if (sqLeader.command == "move")
																bCheck = true;
															else if (sqLeader.command == "sneak")
																bCheck = true;
															else if (sqLeader.command == "advance")
																bCheck = true;
															else if (sqLeader.command == "enter")
																bCheck = true;
															if (bCheck) {
																SetMAIKA(sq.SrcGAIKA, sqGkAiDest, sqGkIn);
																if (bGoAround)
																	if (sq.CalcGoAround()) {
																		Sleep(100);
																		continue;
																	}
															}
														}
														distGoal = sqPos.Dist(sqGkAiDest.Center);
														if (distGoal >= 1500)
															if (distGoal < sqPos.Dist(gFlee.Center))
																gFlee = sqGkAiDest;
													}

												if (gFlee == 0)
													nFlee = 0;
												else if (gFlee == sqGkIn)
													if (enemy > 0)
														nFlee = 0;
													else if (nSqState == SS_Enter)
														nFlee = 0;

												if (nFlee != 0) {
													SetMAIKA(sq.SrcGAIKA, sqGkAiDest, sqGkIn);
													sq.SetState(SS_Flee);
													if (bDetachArmy)
														sqLeaderHero.DetachArmy();
													if (bCoward)
														sq.SendTo(gFlee, 1000);
													else
														sq.SendTo(gFlee, 1);
													Sleep(100);
													continue;
												}
											}
										}

										if (bTakeItems)
											if (sq.TakeNearbyItems(sqLeader.sight)) {
												Sleep(100);
												continue;
											}
									}
								if (nSqState != SS_Catapult)//attach free units (without upgrades, enchantresses and Britain druids are almost useless in combat)
									if (nSqState != SS_Train)
										if (!sqLeader.HasFreedom)
											if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid.IsValid) {
												bool bCheck = false;
												if (!sqLeader.IsHeirOf("IEnchantress")) {
													if (!sqLeader.IsHeirOf("BDruid"))
														bCheck = true;
													else if (IsResearched(aiPlayer, "Mass Heal"))
														bCheck = true;
													else if (IsResearched(aiPlayer, "Mass Concealment"))
														bCheck = true;
												}
												else if (IsResearched(aiPlayer, "Cover of Mercy"))
													bCheck = true;
												else if (IsResearched(aiPlayer, "Restoration"))
													bCheck = true;
												if (bCheck) {
													Unit bestHero;
													int bestEval;
													{//scope to make sure SquadList is deallocated
														SquadList SL;
														Squad squad;
														int eval;
														sqGkIn.GetSquads(SL, AI_STAYING + AI_LEAVING, aiPlayer, AI_OWN);
														SL.Lock();
														for (; !SL.EOL; SL.Next()) {
															squad = SL.Cur;
															if (!squad.Leader.GetFlags(UNITFLAG_NOAI))
																if (!squad.TestFlags(SF_NOAI))
																	if (squad.State != SS_Ruins)
																		if (squad.State != SS_Flee) {
																			eval = sq.EvalAttach(squad.Leader, min);
																			if (eval > 0) {
																				if (sqLeader.AsDruid().IsValid) {
																					int nWant;
																					nWant = squad.Units.count * nMagePerc / 100 - squad.Count("BaseMage");
																					if (nWant > 0)
																						eval = eval * nWant;
																					else
																						continue;
																				}
																				if (squad.Size > 1)
																					if (squad.Count("Horse") == squad.Size - 1)
																						if (sq.Count("Horse") != sq.Size)
																							continue;

																				if (eval > bestEval) {
																					bestHero = squad.Leader;
																					bestEval = eval;
																				}
																			}
																		}
														}
														SL.Unlock();
													}
													if (bestEval > 0)
														if (!sqLeaderHero.IsValid) {
															bool bAttached = true;
															if (!bestHero.InHolder || sq.InHolder) {
																if (nSqState == SS_Attach)
																	if (!sq.InHolder)
																		bAttached = false;
																sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "attach", bestHero);
															}
															else if (setGkIn.IsValid)
																sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "enter", setGkInCentralBuilding);
															if (bAttached) {
																Sleep(100);
																continue;
															}
														}
														else if (bestHero != sqLeaderHero)
															if (sq.Size > 1)
																if (sq.Size < 51)
																	if (bestHero.InHolder)
																		if (sqLeader.SameHolderAs(bestHero)) {//check if transfering army is worth
																			int ev;
																			ev = bestHero.GetSquad().Size + sq.Size - 1;//best hero squad size after attaching
																			if (ev < min)
																				ev = 100 - (min - ev);
																			else
																				ev -= min + 1;
																			//best hero eval after attaching > cur hero eval after detaching
																			if (ev * (1 + bestHero.inherentlevel / 50) > (101 - min) * (1 + sqLeader.inherentlevel / 5)) {
																				sqLeaderHero.DetachArmy();
																				Sleep(100);
																				continue;
																			}
																		}
												}
											}
								if (nSqState == SS_Attach)
									if (sqLeader.command == "idle" || sqLeader.command == "stand_position") {
										sq.DelOrder();
										sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
										Sleep(100);
										continue;
									}
							}

							if (sq.TestFlags(SF_PEACEFUL)) {//make peaceful units go around if endangered or enter a stronghold if idle
								if (sqGkAiDest != sqGkIn)
									if (sqGkAiDest != sq.SrcGAIKA)
										if (sq.DestGAIKA == sqGkAiDest)
											if (sqLeader.command == "move" || sqLeader.command == "enter" || sqLeader.command == "unload") {
												sqGkIn.Eval(AI_STAYING, aiPlayer, own, ally, enemy, enemy_hidden);
												if (enemy > 1000)
													if (own + ally < 500) {
														SetMAIKA(sq.SrcGAIKA, sqGkAiDest, sqGkIn);
														if (bGoAround)
															if (sq.CalcGoAround()) {
																Sleep(100);
																continue;
															}
													}
											}
								if (sqLeader.command == "idle" || sqLeader.command == "stand_position")
									if (!sq.InHolder) {
										Settlement s;
										s = NearestStronghold(sqLeader.pos, aiPlayer);
										if (s.IsValid)
											if (sqLeader.AsWagon().IsValid)
												sqLeader.SetCommand("unload", s.GetCentralBuilding());
											else
												sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
									}
									else if (sqLeader.AsWagon().IsValid)
										if (sqLeader.InHolder)
											sqLeader.SetCommand("unload", sqLeader.GetHolderSett().GetCentralBuilding());
							}

							if (sqLeaderHero.IsValid)//balance mages in the hero army
								if (setGkIn.IsValid)
									if (setGkIn.IsStronghold) {
										int nBalance;
										nBalance = sq.Count("BaseMage") - sq.Size * nMagePerc / 100;
										if (nBalance > 0) {
											ObjList sqUnits;
											Unit u;
											int j;

											sqUnits = sq.Units;
											for (j = 0; j < sqUnits.count; j += 1) {//note that i is used in the original script (which leads to strange loop behaviours)
												u = sqUnits[j].AsUnit();
												if (u.IsValid)
													if (u.IsAlive)
														if (u.IsHeirOf("BaseMage"))
															if (u.hero == sqLeaderHero) {
																u.DetachFrom(sqLeaderHero);
																nBalance -= 1;
																if (nBalance <= 0)
																	break;
															}
											}
										}
									}

							Sleep(48);//without this instruction, the game crashes
						}
		}
		Sleep(2);
	}
	Sleep(nSleepSquadMonitor);
}