//void, Settlement set

//called by ES_Stronghold, this script manages the desperate defence of the stronghold and the recruitment of heroes and units

int aiPlayer, nRace;
StrArray imperialOrPunicOrGreekTrainCmds;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false, bDesperateDefence = true;

aiPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else if (IsResearched(set, "ChoosePunicRome"))
		nRaceIsPunicRome = true;

if (nRaceIsImperialRome) {
	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatus";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcher";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRVelit";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciple";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScout";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianBase";
}
else if (nRaceIsPunicRome) {
	imperialOrPunicOrGreekTrainCmds[0] = "trainRHastatusPunic";
	imperialOrPunicOrGreekTrainCmds[1] = "trainRArcherPunic";
	imperialOrPunicOrGreekTrainCmds[2] = "trainRGladiatorPunic";
	imperialOrPunicOrGreekTrainCmds[3] = "trainRPrinciplePunic";
	imperialOrPunicOrGreekTrainCmds[4] = "trainRScoutPunic";
	imperialOrPunicOrGreekTrainCmds[5] = "trainRPraetorianPunic";
}
else if (nRace == ImperialRome) {//Greece
	imperialOrPunicOrGreekTrainCmds[0] = "trainHPeltast";
	imperialOrPunicOrGreekTrainCmds[1] = "trainHToxotes";
	imperialOrPunicOrGreekTrainCmds[2] = "trainHHoplite";
	imperialOrPunicOrGreekTrainCmds[3] = "trainHCataphract";
	imperialOrPunicOrGreekTrainCmds[4] = "trainHHypaspista";
	imperialOrPunicOrGreekTrainCmds[5] = "trainHChariot";
}

//desperate defence - spam a huge amount of basic units if there are enemy units near the townhall
if (nRace == Germany) {
	if (set.food < 600)
		bDesperateDefence = false;
	else if (set.population <= GetConst("MinPopulation"))
		bDesperateDefence = false;
}
else if (set.gold < 600)
	bDesperateDefence = false;
else if (nRace != Carthage)
	if (set.population <= GetConst("MinPopulation"))
		bDesperateDefence = false;
if (bDesperateDefence)
	if (Intersect(VisibleObjsInSight(set.GetCentralBuilding(), "Military"), EnemyObjs(aiPlayer, "Military")).IsEmpty)
		bDesperateDefence = false;
	else {
		int i, gold, food;
		str cmd;
		if (nRaceIsImperialRome)
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRaceIsPunicRome)
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRace == ImperialRome)//Greece
			cmd = imperialOrPunicOrGreekTrainCmds[0];
		else if (nRace == Carthage) {
			i = EnvReadInt(set, "SpecializedUnit") - 1;//-1, 0-4 or 6 (5 is for CNoble in the temple)
			if (i == 1)
				cmd = UTrainCmd(i, nRace);//CJavelinThrower
			else if (i == 0)
				cmd = UTrainCmd(i, nRace);//CLibyanFootman
			else
				cmd = UTrainCmd(0, nRace) + "NonSpec";//CLibyanFootman
		}
		else {
			cmd = UTrainCmd(0, nRace);
			if (nRace == Iberia) {
				if (IsResearched(set, "Free Drinks"))
					if (set.CanAfford("Call to arms")) {
						Building b;
						b = set.FindResearchLab("Call to arms");
						if (b.IsValid)
							if (!b.IsBroken)
								if (b.CmdCount("Call to arms") < 1)
									if (GetCmdCost("Call to arms", gold, food)) {
										point ptDummy;
										Obj objDummy;
										set.SpentGoldOnArmy(gold + food / 2);
										b.ExecCmd("Call to arms", ptDummy, objDummy, false);
									}
					}
			}
		}
		if (GetCmdCost(cmd, gold, food)) {
			Barrack barrack;
			if (nRace == ImperialRome) {//Greece
				ObjList buildings;
				Building b;
				int min;
				bool first_time = true;
				buildings = set.Buildings;
				for (i = buildings.count - 1; i >= 0; i -= 1) {
					b = buildings[i];
					if (b.IsHeirOf("HBarracks"))//using IsHeirOf is better than a direct class check because it manages winter variants
						if (!b.IsBroken)
							if (first_time) {
								first_time = false;
								min = b.CmdCount;
								barrack = b;
							}
							else if (b.CmdCount < min) {
								min = b.CmdCount;
								barrack = b;
							}
				}
			}
			else
				barrack = set.BestBarrack(100);
			if (barrack.IsValid)
				if (!barrack.IsBroken) {
					i = MIN(30, set.MaxAffordCount(cmd));
					if (i > 0) {
						point ptDummy;
						Obj objDummy;
						set.SpentGoldOnArmy((gold + food / 2) * i);
						while (i > 0) {
							barrack.ExecCmd(cmd, ptDummy, objDummy, false);
							i -= 1;
						}
					}
				}
		}
	}

if (!bDesperateDefence) {
	int i, nCount;
	bool bHireHero = true;

	//hero support
	{
		SquadList SL;
		Squad sq;
		Unit sqLeader;
		Hero h;

		set.GetGaika().GetSquads(SL, AI_STAYING + AI_COMING, aiPlayer, AI_OWN);
		SL.Lock();
		while (!SL.EOL) {
			sq = SL.Cur;
			if (!sq.TestFlags(SF_PEACEFUL + SF_NOAI)) {
				sqLeader = sq.Leader;
				if (sqLeader.IsAlive)
					if (!sqLeader.GetFlags(UNITFLAG_NOAI)) {
						h = sqLeader.AsHero();
						if (h.IsValid) {
							nCount += 1;
							if (h.army.count < h.maxarmy / 2)
								if (rand(3) == 0) {
									bHireHero = false;
									break;
								}
						}
						else if (!sqLeader.HasFreedom)//detached units
							i += sq.Size;
					}
			}
			SL.Next();
		}
		SL.Unlock();
	}

	if (bHireHero)
		if (nCount >= 1)
			if (i < 6)
				bHireHero = false;
			else if (HeroArmiesFullPerc(aiPlayer) < 60)
				bHireHero = false;

	if (bHireHero) {
		str cmd;
		if (nRaceIsImperialRome)
			cmd = "hireheroRImperial";
		else if (nRaceIsPunicRome)
			cmd = "hireheroRPunic";
		else if (nRace == ImperialRome)//Greece
			cmd = "hireheroH";
		else
			cmd = "hirehero" + GetRaceStrPref(nRace);
		if (set.CanResearch(cmd))
			if (set.CanAfford(cmd)) {
				int gold, food;
				if (GetCmdCost(cmd, gold, food)) {
					set.SpentGoldOnArmy(gold + food / 2);
					set.Research(cmd);
					bHireHero = false;
				}
			}
	}

	//build army in barracks
	if (EnvReadInt(set, "AssUnderFire") > 0)
		i = -1;
	else if (!bHireHero)
		if (EnvReadInt(set, "FreezeArmyBuild") <= 0)
			i = -1;

	if (i == -1) {
		Barrack barrack;
		int nBuildType;

		nBuildType = EnvReadInt(set, "nBuildType");
		nCount = EnvReadInt(set, "nBuildCount");

		if (nRace == ImperialRome) {//Greece
			ObjList buildings;
			Building b;
			int min;
			bool first_time = true;
			buildings = set.Buildings;
			for (i = buildings.count - 1; i >= 0; i -= 1) {
				b = buildings[i];
				if (b.IsHeirOf("HBarracks"))//using IsHeirOf is better than a direct class check because it manages winter variants
					if (!b.IsBroken)
						if (first_time) {
							first_time = false;
							min = b.CmdCount;
							barrack = b;
						}
						else if (b.CmdCount < min) {
							min = b.CmdCount;
							barrack = b;
						}
			}
		}
		else {
			barrack = set.BestBarrack(10);
			if (nRace == Carthage)
				if (nCount > 0)
					if (nBuildType == 5)//CNoble management (in "Nemesis of the Roman Empire" they were recruited in the barracks)
						barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
		}

		if (barrack.IsValid)
			if (!barrack.IsBroken)
				if (barrack.CmdCount < 2) {//available barrack
					if (nCount <= 0) {//ask for new units to build
						if (nRace == Germany)
							set.AIRun("ESH_BuildGermanArmy.vs");
						else if (nRace == Carthage)
							set.AIRun("ESH_BuildCarthaginianArmy.vs");
						else
							set.AIRun("ESH_BuildArmy.vs");

						nBuildType = EnvReadInt(set, "nBuildType");
						nCount = EnvReadInt(set, "nBuildCount");

						if (nCount > 0) {
							EnvWriteInt(set, "nArmyBuilds", MIN(1 + EnvReadInt(set, "nArmyBuilds"), 11));//11 is to avoid possible overflow and because managed max value is 10
							if (nRace == Carthage)
								if (nBuildType == 5)
									barrack = set.FindResearchLab(UTrainCmd(5, Carthage));
						}
					}
					if (nCount > 0)
						if (barrack.IsValid)//check validity again because of Carthage case above
							if (!barrack.IsBroken) {
								int gold, food;
								str cmd;

								if (nRaceIsImperialRome)
									if (nBuildType == 5)
										if (IsResearched(set, "Spiked armor II"))
											cmd = "trainRPraetorianDiscounted";
										else
											cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
									else
										cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
								else if (nRaceIsPunicRome)
									cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
								else if (nRace == ImperialRome)//Greece
									cmd = imperialOrPunicOrGreekTrainCmds[nBuildType];
								else if (nRace == Carthage)
									if (nBuildType == 6)
										cmd = "trainCHorseman";
									else
										cmd = UTrainCmd(nBuildType, nRace);
								else
									cmd = UTrainCmd(nBuildType, nRace);

								//wait for a research to finish in order to optimize useful upgrades
								if (nCount > 0)
									if (nRace == Carthage) {
										if (nBuildType < 5) {
											if (IsResearching(set, UTech(nBuildType, nRace)))
												nCount = 0;
										}
										else if (nBuildType == 6)
											if (IsResearching(set, "Forge shields"))
												nCount = 0;
									}
									else if (nRaceIsImperialRome) {
										if (IsResearching(aiPlayer, "Flexibility"))
											nCount = 0;
										else if (nBuildType == 5)
											if (IsResearching(set, "Spiked armor II"))
												nCount = 0;
									}
									else if (nRace == Britain) {
										if (nBuildType == 5)
											if (IsResearching(set, "Steel Weapons"))
												nCount = 0;
									}
									else if (nRace == Gaul)
										if (IsResearching(set, "Nordic trade routes"))
											nCount = 0;
										else if (IsResearching(set, "Belts of Might"))
											nCount = 0;
										else if (IsResearching(set, "Herb amulets"))
											nCount = 0;

								if (nRace == Carthage)
									if (nBuildType < 5) {
										if (!IsResearched(set, UTech(nBuildType, nRace)))
											cmd = cmd + "NonSpec";
									}
									else if (nBuildType == 6)
										if (!IsResearched(set, "Forge shields"))
											cmd = cmd + "NonSpec";

								if (GetCmdCost(cmd, gold, food)) {
									i = MIN(10, MIN(nCount, set.MaxAffordCount(cmd)));
									if (i > 0) {
										point ptDummy;
										Obj objDummy;
										nCount -= i;
										EnvWriteInt(set, "nBuildCount", nCount);
										set.SpentGoldOnArmy((gold + food / 2) * i);
										while (i > 0) {
											barrack.ExecCmd(cmd, ptDummy, objDummy, false);
											i -= 1;
										}
									}
								}
							}
				}
	}
}