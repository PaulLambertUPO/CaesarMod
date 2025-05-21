//void

Settlement setGIn, setGDest;
Building setGInCentralBuilding, setGDestCentralBuilding;
int AIPlayer, nMilUnits, nMagePerc, time, min, i;
bool bGoAround, bCoward;

Sleep(rand(1000) + 300);

while (1) {
	AIPlayer = AIGetPlayer();
	nMilUnits = MilUnits(AIPlayer);
	nMagePerc = AIVar(AIPlayer, AIV_MageAttach);
	bGoAround = AIVar(AIPlayer, AIV_GoAround) != 0;
	bCoward = AIVar(AIPlayer, AIV_Coward) != 0;

	time = GetTime() / 60000;
	if (time < 10)
		min = 15;
	else if (time < 20)
		min = 20;
	else if (time < 30)
		min = 31;
	else
		min = 41;

	if (min < nMilUnits / 4)
		min = MIN(41, nMilUnits / 4);

	for (i = 1; i < NumSquads(AIPlayer); i += 1) {
		Squad sq;
		Unit sqLeader;
		int nSqState, nSqStateTime;

		sq = GetSquad(AIPlayer, i);
		sqLeader = sq.Leader;
		nSqState = sq.State;
		nSqStateTime = sq.StateTime;

		if (sq.Eval == 0)
			continue;
		if (!sqLeader.IsValid)
			continue;
		if (sq.TestFlags(SF_NOAI))
			continue;
		if (sqLeader.GetFlags(UNITFLAG_NOAI))
			continue;
		if (IsWaterLsa(sq.GAIKAIn.LSA))//ships and units in ships are not monitored
			if (sq.InHolder)
				continue;
			else if (sqLeader.AsShip().IsValid)
				continue;

		setGIn = sq.GAIKAIn.settlement;
		setGDest = sq.AIDest.settlement;

		setGInCentralBuilding = setGIn.GetCentralBuilding();
		setGDestCentralBuilding = setGDest.GetCentralBuilding();

		//approach to capture a settlement when we move around it
		if (nSqState == SS_Approach || nSqState == SS_IDLE) {
			if (setGIn.IsValid)
				if (setGIn.IsIndependent)
					if (setGIn.IsOutpost && !setGIn.IsIndependentGuarded || setGIn.IsVillage || setGIn.IsShipyard) {
						point ptBld;
						int nDist, nSight;
						sqLeader.SetVisible(true);
						sqLeader.SetLastAttackTime();
						ptBld = setGInCentralBuilding.pos;
						nDist = sqLeader.DistTo(ptBld);
						nSight = setGInCentralBuilding.sight * 2 / 3;
						if (nDist > nSight) {
							point pt;
							pt = ptBld + (sqLeader.pos - ptBld) * nSight / nDist;
							sq.Units.SetCommand("advance", pt);
							if (sq.AIDest > 0)
								sq.Units.AddCommand(false, "advance", sq.AIDest.Center);
							continue;
						}
					}

			//gather staying army together
			if (sqLeader.command == "idle")
				if (sq.GAIKAIn != sq.AIDest)
					if (setGDest.IsValid)
						if (setGDest.IsEnemy(AIPlayer))
							if (setGIn.IsOutpost || setGIn.IsVillage || setGIn.IsShipyard)
								if (setGDestCentralBuilding.DistTo(sq.pos) < 2000) {
									int own, ally, enemy, enemy_hidden;
									sq.AIDest.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
									if (own + ally + sq.Eval > enemy * 2) {
										sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGDestCentralBuilding.pos);
										continue;
									}
								}
		}

		if (nSqState != SS_IDLE)
			if (nSqState != SS_ApproachWait)
				if (nSqState != SS_Siege)
					if (nSqState != SS_Catapult)
						if (!sqLeader.InHolder)
							if (sqLeader.command == "idle") {
								sq.DelOrder;
								sq.SetState(SS_IDLE);
							}

		if (nSqState == SS_KillAll)
			if (sqLeader.command == "ai_killall" || sqLeader.command == "idle" || sqLeader.command == "stand_position") {
				if (setGDest.IsValid)
					if (!sqLeader.IsVisible()) {
						sqLeader.SetVisible(true);
						sqLeader.SetLastAttackTime();
					}
				if (nSqStateTime > 60000)
					if (setGDest.IsValid) {
						if (setGDestCentralBuilding.DistTo(sq.pos) > 500)
							sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "advance", setGDestCentralBuilding.pos);
						else if (setGIn.IsAlly(AIPlayer))
							sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGInCentralBuilding);
					}
					else
						sq.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
			}

		if (nSqState == SS_Catapult)
			if (!sqLeader.InHolder)
				if (sqLeader.command != "build_catapult")
					sq.SetState(SS_IDLE);

		if (nSqState == SS_IDLE)
			if (sqLeader.command == "idle")
				if (!sq.InHolder)
					if (sq.GAIKAIn == sq.AIDest)
						if (sq.GAIKAIn.StratRunning(AIPlayer) == GS_EnterSettlement)
							if (!sq.TestFlags(SF_PEACEFUL))
								if (!sq.TestFlags(SF_NOAI))
									sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGInCentralBuilding);

		if (nSqState == SS_IDLE || nSqState == SS_Enter)
			if (sqLeader.command == "idle") {
				if (sq.AIDest > 0 && sq.GAIKAIn != sq.AIDest) {
					sq.SendTo(sq.AIDest, 1);
					Sleep(100);
					continue;
				}
				else if (sq.Units.count <= 10)//send units from tents and other small armies at home
					if (sq.Eval < 5000)
						if (sq.GAIKAIn.StratRunning(AIPlayer) == GS_NONE || sq.GAIKAIn.StratRunning(AIPlayer) == GS_EnterSettlement)
							if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid().IsValid)
								if (sqLeader.GetHolderSett().IsTTent) {
									if (rand(15) == 0)
										if (sqLeader.GetHolderSett().UnitsCount >= 8) {
											Settlement s;
											s = NearestStronghold(sq.pos, sq.Player);
											if (s.IsValid) {
												SquadList SL;
												sq.GAIKAIn.GetSquads(SL, AI_STAYING, AIPlayer);
												SL.Lock;
												for (0; !SL.EOL; SL.Next)
													if (SL.Cur.Leader.GetHolderSett().IsTTent)
														sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
												SL.Unlock;
												Sleep(100);
												continue;
											}
										}
								}
								else if (!sq.InHolder && GetTime() > 900000 || !sqLeader.GetHolderSett().IsStronghold && !sqLeader.AsHero().IsValid && !sqLeader.HasFreedom()) {
									Settlement s;
									s = NearestStronghold(sq.pos, sq.Player);
									if (s.IsValid) {
										sq.SetCmd(SS_Flee, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
										Sleep(100);
										continue;
									}
								}
			}

		//retreat idle units from tower/sentry range
		if (nSqState == SS_IDLE || nSqState == SS_Wait)
			if (sqLeader.command == "idle" || sqLeader.command == "stand_position")
				if (sq.LastFightTime > GetTime() - 3000)
					if (sq.GetLastAttacker().IsValid)
						if (sq.GetLastAttacker().AsBuilding().IsValid || sq.GetLastAttacker().IsSentry) {
							point pt;
							pt = sq.pos - sq.GetLastAttacker().pos;
							pt.SetLen(100);
							sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sq.pos + pt);
						}

		//use ruins
		if (AIVar(AIPlayer, AIV_UseRuins) != 0)
			if (rand(3) == 0)
				if (sq.InHolder)
					if (sqLeader.AsHero().IsValid)
						if (setGIn.IsStronghold) {
							Obj ruins;
							if (nSqState == SS_Ruins)
								sq.SetState(SS_IDLE);
							ruins = FindRuins(sq.pos, 8000, sqLeader.level);
							if (ruins.IsValid) {
								sqLeader.AsHero().DetachArmy();
								sq.SetCmd(SS_Ruins, 0, SF_ADVCHOOSER, "enter", ruins);
								sqLeader.AddCommand(false, "enter", setGInCentralBuilding);
								Sleep(100);
								continue;
							}
						}

		//use items
		if (sqLeader.item_count > 0)
			if (sqLeader.AsHero().IsValid) {
				Item water_bowl, water_bag;
				int amount_bowl, amount_bag;

				water_bowl = sqLeader.FindItem("Healing water");
				if (water_bowl.IsValid)
					amount_bowl = water_bowl.use_count;

				water_bag = sqLeader.FindItem("Bag of healing water");
				if (water_bag.IsValid)
					amount_bag = water_bag.use_count;

				if (sqLeader.HasItem("Poison Mushroom"))
					if (sqLeader.HasItem("Healing herbs"))
						sqLeader.UseItem("Poison Mushroom");
					else if (sqLeader.HasItem("Ash of druid heart"))
						sqLeader.UseItem("Poison Mushroom");
					else if (sqLeader.HasItem("Ring of Power"))
						sqLeader.UseItem("Poison Mushroom");
					else if (sqLeader.HasItem("Elephant Tusk"))
						sqLeader.UseItem("Poison Mushroom");
					else if (sqLeader.maxhealth / 2 <= MAX(amount_bowl, amount_bag))//use if possible to heal at least 50% max health with water
						sqLeader.UseItem("Poison Mushroom");

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

				if (rand(2) == 0)//avoid spamming items
					if (sqLeader.HasItem("Horn of victory") || sqLeader.HasItem("Finger of death") || sqLeader.HasItem("Battle Drums of Rage")
							|| sqLeader.HasItem("Skull of Pain") && sqLeader.health >= sqLeader.maxhealth * 3 / 4) {
						int own, ally, enemy, enemy_hidden, nMinNeed;
						sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
						nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
						if (own + ally < nMinNeed * 5 / 4) {//difficult situation
							if (sqLeader.HasItem("Horn of victory"))
								sqLeader.UseItem("Horn of victory");
							if (sqLeader.HasItem("Finger of death"))
								sqLeader.UseItem("Finger of death");
							if (sqLeader.HasItem("Skull of Pain"))
								sqLeader.UseItem("Skull of Pain");
							if (sqLeader.HasItem("Battle Drums of Rage"))
								if (sqLeader.command == "ai_killall")
									sqLeader.UseItem("Battle Drums of Rage");
								else if (sqLeader.command == "attack")
									sqLeader.UseItem("Battle Drums of Rage");
								else if (sqLeader.command == "engage")
									sqLeader.UseItem("Battle Drums of Rage");
								else if (nSqState == SS_KillAll)
									sqLeader.UseItem("Battle Drums of Rage");
						}
					}
			}

		//check feeding
		if (nSqState != SS_Flee)
			if (sq.Eval >= 3000) {
				int dist, food, needed;
				dist = sq.pos.Dist(sq.AIDest.Center) + 200;//add 200 to help feeding already hungry squads
				food = sq.food + sq.FoodComing;
				needed = sq.Size * dist / 700;
				if (AIVar(AIPlayer, AIV_SynchApproach))
					needed = needed * 4 / 3;
				if (food + 100 < needed)//do not ask for less than 100 food
					sq.SendFoodWagon(needed - food, 3000);
			}

		//stop for healing
		if (nSqState == SS_Flee)
			if (sq.food > 100)
				if (!sq.InHolder)
					if (sqLeader.AsHero().IsValid)
						if (!sqLeader.BestTargetInSquadSight.IsValid) {
							int healers, minHealers = 7;
							healers = sq.Count("GDruid");
							if (healers < minHealers) {
								healers += sq.Count("RPriest");
								if (healers < minHealers)
									healers += sq.Count("HPriest");
							}
							if (healers >= minHealers)
								sq.SetCmd(SS_IDLE, 0, SF_ADVCHOOSER, "move", sqLeader.pos);
						}

		//flee behaviour
		if (nSqState != SS_Flee)
			if (nSqState != SS_Ruins) {
				if (sqLeader.AsHero().IsValid) {
					bool bHeroHurt = false, bDetachArmy = false;
					int nFlee = 0;//2-hero_dying, 4-army_dying, 8-losing

					if (sqLeader.health < sqLeader.maxhealth / 2)
						if (sqLeader.BestTargetInSquadSight.IsAlive) {
							bHeroHurt = true;
							nFlee += 2;
							if (sqLeader.health < sqLeader.maxhealth / 3)
								bDetachArmy = true;
						}

					if (bCoward) {
						bool bFleeCheck = false;
						if (sq.health < sq.maxhealth / 2)
							if (!sqLeader.AsHero().SkillInEffect(hsFrenzy))//avoid fleeing if the skill has just been activated
								nFlee += 4;
						if (sq.AIDest == sq.GAIKAIn)
							bFleeCheck = true;
						if (!bFleeCheck)
							if (setGIn.IsTTent)
								if (setGIn.IsEnemy(AIPlayer))
									if (sqLeader.command == "engage")
										bFleeCheck = true;
						if (bFleeCheck) {
							int own, ally, enemy, enemy_hidden, nMinNeed;
							sq.GAIKAIn.Eval(AI_ALL, AIPlayer, own, ally, enemy, enemy_hidden);
							if (own + ally < sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy) / 2)
								nFlee += 8;
						}
					}

					if (!bHeroHurt)
						if (nFlee != 0)
							if (nFlee != 8) {
								int own, ally, enemy, enemy_hidden, nMinNeed;
								sq.AIDest.Eval(AI_COMING + AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
								nMinNeed = sq.GAIKAIn.MinNeed(AIPlayer, own, ally, enemy);
								if (own + ally >= nMinNeed)
									if (sq.Size > 6) {
										int n;
										n = own + ally - sq.Eval;
										if (n > 0)
											if (n < nMinNeed)//don't flee if allies can't do it
												nFlee = 0;
									}
							}

					if (nFlee != 0) {
						int own, ally, enemy, enemy_hidden;

						sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
						enemy += sq.GAIKAIn.Eval(AI_LEAVING, AIPlayer, AI_ENEMY);
						if (enemy == 0)
							if (setGIn.IsEnemy(AIPlayer))
								if (setGIn.CanBeCaptured())
									nFlee = 0;

						if (nFlee != 0) {
							GAIKA gFlee;
							gFlee = NearestHospital(sq);
							if (gFlee == 0)	{
								int nHomeGaikaID;
								nHomeGaikaID = EnvReadInt(AIPlayer, "HomeGaika");
								if (nHomeGaikaID > 0)
									gFlee = GetGAIKA(nHomeGaikaID);
							}
							if (nFlee == 8)
								if (sq.AIDest != sq.GAIKAIn) {//ambushed but otherwise ok, decide where to flee
									int distGoal, distHospital;

									if (sq.DestGAIKA == sq.AIDest)
										if (sqLeader.command == "move" || sqLeader.command == "sneak" || sqLeader.command == "advance" || sqLeader.command == "enter") {
											SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
											if (bGoAround)
												if (sq.CalcGoAround) {
													Sleep(100);
													continue;
												}
									}
									distGoal = sq.pos.Dist(sq.AIDest.Center);
									distHospital = sq.pos.Dist(gFlee.Center);
									if (distGoal >= 1500)
										if (distGoal < distHospital)
											gFlee = sq.AIDest;
								}

							if (gFlee == 0)
								nFlee = 0;
							else if (gFlee == sq.GAIKAIn)
								if (enemy != 0)
									nFlee = 0;
								else if (nSqState == SS_Enter)
									nFlee = 0;

							if (nFlee != 0) {
								SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
								sq.SetState(SS_Flee);
								if (bDetachArmy)
									sqLeader.AsHero().DetachArmy();
								if (bCoward)
									sq.SendTo(gFlee, 1000);
								else
									sq.SendTo(gFlee, 1);
								Sleep(100);
								continue;
							}
						}
					}
				}

				//take items from nearby item holders
				if (sqLeader.AsHero().IsValid)
					if (AIVar(AIPlayer, AIV_TakeItems) != 0)
						if (sq.TakeNearbyItems(sqLeader.sight)) {
							Sleep(100);
							continue;
						}
			}

		if (nSqState == SS_Flee)
			if (sq.InHolder)
				sq.SetState(SS_IDLE);
			else {
				if (sqLeader.AsHero().IsValid)
					if (sqLeader.health < sqLeader.maxhealth / 3)
						sqLeader.AsHero().DetachArmy();
				if (sq.pos.Dist(sq.AIDest.Center) <= 1500 || !sqLeader.BestTargetInSquadSight.IsValid)
					if (sq.GAIKAIn == sq.AIDest) {
						if (!setGIn.IsAlly(AIPlayer))
							sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
						else if (setGIn.IsFull())
							sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
						else
							sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", setGInCentralBuilding);
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

		//attach free units (enchantresses and Britain druids are almost useless without upgrades)
		if (nSqState != SS_Catapult)
			if (nSqState != SS_Train)
				if (nSqState != SS_Flee)
					if (!sq.TestFlags(SF_PEACEFUL) || sqLeader.AsDruid.IsValid)
						if (!sqLeader.AsShip().IsValid)
							if (!sqLeader.HasFreedom())
								if (!sqLeader.IsHeirOf("IEnchantress") && !sqLeader.IsHeirOf("BDruid")
										|| sqLeader.IsHeirOf("IEnchantress") && (IsResearched(AIPlayer, "Cover of Mercy") || IsResearched(AIPlayer, "Restoration"))
										|| sqLeader.IsHeirOf("BDruid") && (IsResearched(AIPlayer, "Mass Heal") || IsResearched(AIPlayer, "Mass Concealment"))) {
									Unit bestHero;
									int bestEval;

									//scope to ensure SquadList destruction
									{
										SquadList SL;
										int eval;
										for (sq.GAIKAIn.GetSquads(SL, AI_STAYING + AI_LEAVING, AIPlayer, AI_OWN); !SL.EOL; SL.Next) {
											Squad squad;
											squad = SL.Cur;
											if (squad.TestFlags(SF_NOAI))
												continue;
											if (squad.Leader.GetFlags(UNITFLAG_NOAI))
												continue;
											eval = sq.EvalAttach(squad.Leader, min);
											if (eval == 0)
												continue;
											if (squad.State == SS_Ruins)
												continue;
											if (squad.State == SS_Flee)
												continue;
											if (sqLeader.AsDruid().IsValid) {
												int nWant;
												nWant = squad.Units.count * nMagePerc / 100 - squad.Count("BaseMage");
												if (nWant > 0)
													eval = eval * nWant;
												else
													continue;
											}
											if (squad.Size != 1)
												if (squad.Count("Horse") == squad.Size - 1)
													if (sq.Count("Horse") != sq.Size)
														continue;

											if (eval > bestEval) {
												bestHero = squad.Leader;
												bestEval = eval;
											}
										}
									}
									if (bestEval > 0)
										if (!sqLeader.AsHero().IsValid) {
											bool bAttached = true;
											if (!bestHero.InHolder || sq.InHolder) {
												if (nSqState == SS_Attach)
													if (!sq.InHolder)
														bAttached = false;
												sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "attach", bestHero);
											}
											else if (setGIn.IsValid)
												sq.SetCmd(SS_Attach, 0, SF_ADVCHOOSER, "enter", setGInCentralBuilding);
											if (bAttached) {
												Sleep(100);
												continue;
											}
										}
										else if (bestHero != sqLeader.AsHero())
											if (sq.Size > 1)
												if (sq.Size < 51)
													if (bestHero.InHolder)
														if (sqLeader.SameHolderAs(bestHero)) {//check if worth transfering army
															int e1, e2;
															e1 = (101 - min) * (1 + sqLeader.level / 5);//cur hero eval after detaching
															e2 = bestHero.GetSquad().Size + sq.Size - 1;//best hero squad size after attaching
															if (e2 < min)
																e2 = 100 - (min - e2);
															else
																e2 -= min + 1;
															e2 = e2 * (1 + bestHero.level / 50);//best hero eval after attaching
															if (e1 < e2) {//still worth it
																sqLeader.AsHero().DetachArmy();
																Sleep(100);
																continue;
															}
														}
								}
		if (nSqState == SS_Attach)
			if (sqLeader.command == "idle") {
				sq.DelOrder;
				sq.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
				Sleep(100);
				continue;
			}

		//peaceful go around
		if (sq.TestFlags(SF_PEACEFUL)) {
			if (sq.AIDest != sq.GAIKAIn)
				if (sq.AIDest != sq.SrcGAIKA)
					if (sq.DestGAIKA == sq.AIDest)
						if (sqLeader.command == "move" || sqLeader.command == "enter" || sqLeader.command == "unload") {
							int own, ally, enemy, enemy_hidden;
							sq.GAIKAIn.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
							if (enemy > 1000 && own + ally < 500) {
								SetMAIKA(sq.SrcGAIKA, sq.AIDest, sq.GAIKAIn);
								if (bGoAround)
									if (sq.CalcGoAround) {
										Sleep(100);
										continue;
									}
							}
						}
			if (sqLeader.command == "idle")
				if (!sq.InHolder) {
					Settlement s;
					s = NearestStronghold(sqLeader.pos, AIPlayer);
					if (s.IsValid)
						sq.SetCmd(SS_Enter, 0, SF_ADVCHOOSER, "enter", s.GetCentralBuilding());
				}
		}

		if (sqLeader.AsHero().IsValid)
			if (setGIn.IsStronghold) {
				int nMages, nWant, nBalance;
				nMages = sq.Count("BaseMage");
				nWant = sq.Units.count * nMagePerc / 100;
				nBalance = nMages - nWant;
				if (nBalance > 0) {
					ObjList olDetach;
					Hero hero;
					hero = sqLeader.AsHero();

					for (i = 0; i < sq.Units.count; i += 1) {
						Unit u;
						u = sq.Units[i].AsUnit();
						if (u.IsValid)
							if (u.IsHeirOf("BaseMage")) {
								olDetach.Add(u);
								nBalance -= 1;
								if (nBalance <= 0)
									break;
							}
					}
					for (i = 0; i < olDetach.count; i += 1)
						olDetach[i].AsUnit().DetachFrom(hero);
				}
			}

		//nothing for this squad
		Sleep(50);
	}
	Sleep(AIVar(AIPlayer, AIV_Sleep_SquadMonitor));
}