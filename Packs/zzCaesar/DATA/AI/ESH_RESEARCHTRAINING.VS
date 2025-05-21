//void, Settlement set

//called by ES_Stronghold, this script manages researches whose main focus is to improve troops and heroes (exclusive unit upgrades are not considered)
//be careful: research commands to be issued to the settlement sometimes have different names from what they set in the player/settlement environment

int Greece, AIPlayer, nRace, nMaxLevelTraining;
str strTech, strTech2, strTech3;

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (EnvReadInt(set, "ResearchTrainingComplete") != 1) {
	if (nRace == Gaul) {
		//fights -> battle_tactics -> warrior_tales -> training_1_2_3 -> tavern_items | parallel tavern_items after battle_tactics
		strTech = "Fights";
		if (IsResearched(set, strTech)) {
			strTech = "Battle tactics";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Warrior Tales";
				if (IsResearched(AIPlayer, strTech)) {
					nMaxLevelTraining = EnvReadInt(AIPlayer, "maxtrainlevel");
					if (nMaxLevelTraining < 12) {
						if (nMaxLevelTraining < 4)
							strTech = "Gaul Training 1";
						else if (nMaxLevelTraining < 8)
							strTech = "Gaul Training 2";
						else
							strTech = "Gaul Training 3";
					}
					else
						strTech = "";
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(3) == 0 && IsResearched(AIPlayer, "Battle tactics")) {
			strTech2 = "Free Beer";
			if (IsResearched(set, strTech2)) {
				strTech2 = "Nordic trade routes";
				if (IsResearched(set, strTech2)) {
					strTech2 = "Belts of Might";
					if (IsResearched(set, strTech2)) {
						strTech2 = "Herb amulets";
						if (IsResearched(set, strTech2))
							strTech2 = "";
					}
				}
			}
		}
	}
	else if (nRace == RepublicanRome) {
		if (IsResearched(set, "ChooseRepublicanRome")) {
			//gladiator_shows -> training 1_2 -> nobility -> veteran_offence_health_defence -> God_gift | parallel God_gift after gladiator_shows
			strTech = "RGladiator Shows";
			if (IsResearched(set, strTech)) {
				nMaxLevelTraining = EnvReadInt(AIPlayer, "maxtrainlevel");
				if (nMaxLevelTraining < 8) {
					if (nMaxLevelTraining < 4)
						strTech = "Rome Training 1";
					else
						strTech = "Rome Training 2";
				}
				else {
					strTech = "RNobility";
					if (IsResearched(AIPlayer, strTech)) {
						strTech = "Veteran Offence";
						if (IsResearched(AIPlayer, strTech)) {
							strTech = "Veteran Health";
							if (IsResearched(AIPlayer, strTech)) {
								strTech = "Veteran Defence";
								if (IsResearched(AIPlayer, strTech))
									strTech = "";
							}
						}
					}
				}
			}
			if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(3) == 0 && IsResearched(set, "Gladiator Shows")) {
				strTech2 = "Altar of Jupiter";
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}
			}
		}
		else if (IsResearched(set, "ChooseImperialRome")) {
			//gladiator_shows -> military_academy -> standarditazion_1-2-3 -> God_gift -> import_horses | parallel God_gift after military_academy | parallel import_horses after military_academy
			strTech = "RGladiator Shows2";
			if (IsResearched(set, strTech)) {
				strTech = "Military Academy";
				if (IsResearched(set, strTech)) {
					strTech = "Standartization I";
					if (IsResearched(AIPlayer, strTech)) {
						strTech = "Standartization II";
						if (IsResearched(AIPlayer, strTech)) {
							strTech = "Flexibility";
							if (IsResearched(AIPlayer, strTech))
								strTech = "";
						}
					}
				}
			}
			if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(3) == 0 && IsResearched(set, "Military Academy")) {
				strTech2 = "Altar of Jupiter";
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}
			}
			if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(10) == 0 && IsResearched(set, "Military Academy")) {
				strTech3 = "Free Wine";
				if (IsResearched(set, strTech3)) {
					strTech3 = "Import horses";
					if (IsResearched(set, strTech3))
						strTech3 = "";
				}
			}
		}
		else if (IsResearched(set, "ChoosePunicRome")) {
			//gladiator shows -> military_academy -> training_1_2_3 -> God_gift -> import_horses | parallel God_gift after military_academy | parallel import_horses after military_academy
			strTech = "Gladiator Shows";
			if (IsResearched(set, strTech)) {
				strTech = "Military Academy";
				if (IsResearched(set, strTech)) {
					nMaxLevelTraining = EnvReadInt(AIPlayer, "maxtrainlevel");
					if (nMaxLevelTraining < 12) {
						if (nMaxLevelTraining < 4)
							strTech = "Training";
						else if (nMaxLevelTraining < 8)
							strTech = "Advanced Training";
						else
							strTech = "Special training";
					}
					else
						strTech = "";
				}
			}
			if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(3) == 0 && IsResearched(set, "Military Academy")) {
				strTech2 = "Altar of Jupiter";
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}
			}
			if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(8) == 0 && IsResearched(set, "Military Academy")) {
				strTech3 = "Free Wine";
				if (IsResearched(set, strTech3)) {
					strTech3 = "Import horses";
					if (IsResearched(set, strTech3))
						strTech3 = "";
				}
			}
		}
	}
	else if (nRace == Carthage) {
		//people_assembly -> spoils_war -> shared_strength_triumph -> mercenary_pact_heal -> ferocity | parallel mercenary_pact_heal after spoils_war | parallel ferocity after spoils_war
		strTech = "People's Assembly";
		if (IsResearched(set, strTech)) {
			strTech = "Spoils of war";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Shared Strength";
				if (IsResearched(set, strTech)) {
					strTech = "Shared Triumph";
					if (IsResearched(set, strTech))
						strTech = "";
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(2) == 0 && IsResearched(AIPlayer, "Spoils of war")) {
			strTech2 = "Free Trade";
			if (IsResearched(set, strTech2)) {
				strTech2 = "Mercenary pact";
				if (IsResearched(AIPlayer, strTech2)) {
					strTech2 = "Mercenary heal";
					if (IsResearched(AIPlayer, strTech2))
						strTech2 = "";
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(8) == 0 && IsResearched(AIPlayer, "Spoils of war")) {
			strTech3 = "Dark Rituals";
			if (IsResearched(set, strTech3)) {
				strTech3 = "Ferocity";
				if (IsResearched(AIPlayer, strTech3))
					strTech3 = "";
			}
		}
	}
	else if (nRace == Iberia) {
		//tournaments -> heroes_wisdom -> veteran_guild -> nobility -> warriors_wisdom -> ancestral_knowledge -> tame_horses | parallel ancestral_knowledge after heroes_wisdom | parallel tame_horses after heroes_wisdom
		strTech = "Tournaments";
		if (IsResearched(set, strTech)) {
			strTech = "Heroes' Wisdom";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Veteran's guild";
				if (IsResearched(set, strTech)) {
					strTech = "Nobility";
					if (IsResearched(AIPlayer, strTech)) {
						strTech = "Warriors' Wisdom";
						if (IsResearched(AIPlayer, strTech))
							strTech = "";
					}
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(4) == 0 && IsResearched(AIPlayer, "Heroes' Wisdom")) {
			strTech2 = "Code of Valor";
			if (IsResearched(AIPlayer, strTech2)) {
				strTech2 = "Ancestral Knowledge";
				if (IsResearched(AIPlayer, strTech2))
					strTech2 = "";
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(10) == 0 && IsResearched(AIPlayer, "Heroes' Wisdom")) {
			strTech3 = "Free Drinks";
			if (IsResearched(set, strTech3)) {
				strTech3 = "Tame horses";
				if (IsResearched(AIPlayer, strTech3))
					strTech3 = "";
			}
		}
	}
	else if (nRace == Britain) {
		//fights -> nobility -> nobility_offence_defence -> gambler_day_luck_test -> steel_weapons | parallel gambler_day_luck_test after fights | parallel steel_weapons after fights
		strTech = "Britain Fights";
		if (IsResearched(set, strTech)) {
			strTech = "BNobility";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Noble Offence";
				if (IsResearched(AIPlayer, strTech)) {
					strTech = "Noble Defence";
					if (IsResearched(AIPlayer, strTech))
						strTech = "";
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(3) == 0 && IsResearched(set, "Fights")) {
			strTech2 = "Gambling";
			if (IsResearched(set, strTech2)) {
				strTech2 = "Gambler's Day";
				if (IsResearched(AIPlayer, strTech2)) {
					strTech2 = "Gambler's Luck";
					if (IsResearched(AIPlayer, strTech2)) {
						strTech2 = "Gambler's Test";
						if (IsResearched(AIPlayer, strTech2))
							strTech2 = "";
					}
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(7) == 0 && IsResearched(set, "Fights")) {
			strTech3 = "Steel Weapons";
			if (IsResearched(set, strTech3))
				strTech3 = "";
		}
	}
	else if (nRace == Germany) {
		//fights -> learning -> attack focus -> barbaric tales | fights -> attack focus -> learning -> barbaric tales
		strTech = "TFights";
		if (IsResearched(set, strTech)) {
			if (rand(2) == 0) {
				strTech = "Learning";
				if (IsResearched(AIPlayer, strTech))
					strTech = "Attack focus";
			}
			else {
				strTech = "Attack focus";
				if (IsResearched(AIPlayer, strTech))
					strTech = "Learning";
			}
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Barbaric Tales";
				if (IsResearched(AIPlayer, strTech))
					strTech = "";
			}
		}
	}
	else if (nRace == Greece) {
		//olympic_games -> government -> spartan_training -> charm_Athena_Aegle -> military_preparation -> statue_Zeus | parallel statue_Zeus after spartan_training
		strTech = "Olympic Games";
		if (IsResearched(set, strTech)) {
			str governmentForm;
			governmentForm = EnvReadString(AIPlayer, "GovernmentForm");
			if (governmentForm != "Democracy" && governmentForm != "Oligarchy") {
				if (rand(3) == 0)
					strTech = "Oligarchy";
				else
					strTech = "Democracy";//democracy has a higher chance to be chosen because it is easier to use
			}
			else {
				strTech = "Spartan Training";
				if (IsResearched(AIPlayer, strTech)) {
					strTech = "Charm of Athena";
					if (IsResearched(AIPlayer, strTech)) {
						strTech = "Charm of Aegle";
						if (IsResearched(AIPlayer, strTech)) {
							strTech = "Military Preparation";
							if (IsResearched(set, strTech))
								strTech = "";
						}
					}
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(5) == 0 && IsResearched(AIPlayer, "Spartan Training")) {
			strTech2 = "Offer to Gods";
			if (IsResearched(set, strTech2)) {
				strTech2 = "Statue of Zeus";
				if (IsResearched(AIPlayer, strTech2))
					strTech2 = "";
			}
		}
	}
	else if (nRace == Egypt) {
		//cult_Anubis -> path_dead_1_2_3 -> cult_Horus -> statue_AmonRa_Osiris_Isis -> light_Horus_1_2_3 -> mumification | parallel mumification after statue_AmonRa
		strTech = "Cult of Anubis";
		if (IsResearched(set, strTech)) {
			strTech = "Path of the dead I";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Path of the dead II";
				if (IsResearched(AIPlayer, strTech)) {
					strTech = "Path of the dead III";
					if (IsResearched(AIPlayer, strTech)) {
						strTech = "Cult of Horus";
						if (IsResearched(set, strTech)) {
							strTech = "Statue of Amon-Ra";
							if (IsResearched(AIPlayer, strTech)) {
								strTech = "Statue of Osiris, father of Horus";
								if (IsResearched(AIPlayer, strTech)) {
									strTech = "Statue of Isis, mother of Anubis";
									if (IsResearched(AIPlayer, strTech)) {
										strTech = "Light of Horus I";
										if (IsResearched(set, strTech)) {
											strTech = "Light of Horus II";
											if (IsResearched(set, strTech)) {
												strTech = "Light of Horus III";
												if (IsResearched(set, strTech))
													strTech = "";
											}
										}
									}
								}
							}
						}
					}
				}
			}
		}
		if (strTech == "" || set.gold >= AIVar(AIPlayer, AIV_ExcessGold) || rand(6) == 0 && IsResearched(AIPlayer, "Statue of Amon-Ra")) {
			strTech2 = "Cult of Osiris";
			if (IsResearched(set, strTech2)) {
				strTech2 = "Mumification";
				if (IsResearched(AIPlayer, strTech2))
					strTech2 = "";
			}
		}
	}

	//parallel researches
	if (strTech2 == "")
		strTech2 = strTech3;
	else {
		EnvWriteString(set, "strTech", strTech3);
		set.AIRun("ESH_NeedTech.vs");
	}
	if (strTech == "")
		strTech = strTech2;
	else {
		EnvWriteString(set, "strTech", strTech2);
		set.AIRun("ESH_NeedTech.vs");
	}

	//when everything has been researched, unlock the execution of the other scripts and avoid checking every tech again and again
	if (strTech == "")
		EnvWriteInt(set, "ResearchTrainingComplete", 1);
	else
		EnvWriteInt(set, "ResearchTrainingComplete", 0);
}

//research additional repeatable upgrades
if (nRace == Egypt) {
	bool getCharms = false;
	if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
		getCharms = true;
	else if (strTech == "")
		if (rand(5) == 0)
			if (set.gold >= 2000)
				getCharms = true;
	if (getCharms) {
		ObjList l;
		Building b;
		Unit u;
		StrArray items, techs;
		int i, j, nCount, min = 30;
		str charm;

		items[0] = "Damage charm";
		items[1] = "Armor charm";
		items[2] = "Health charm";
		items[3] = "Knowledge charm";

		techs[0] = "Charm of Seth";
		techs[1] = "Charm of Thoth";
		techs[2] = "Charm of Ra";
		techs[3] = "Charm of Isis";

		b = set.GetCentralBuilding();
		l = set.ObjectsAround("Military");
		j = rand(4);
		charm = items[j];
		for (i = 0; i < l.count && nCount < min; i += 1) {
			u = l[i].AsUnit();
			if (!b.IsEnemy(u))
				if (!u.IsSentry)
					if (!u.AsHero().IsValid)
						if (!u.HasItem(charm))
							nCount += 1;
		}
		if (nCount >= min)
			strTech = techs[j];
	}
}

if (nRace == RepublicanRome || nRace == Carthage || nRace == Germany) {
	bool townTraining = false;
	if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount))
		townTraining = true;
	else if (strTech == "")
		if (rand(5) == 0)
			if (set.gold >= 3500)
				townTraining = true;
	if (townTraining) {
		Building b;
		ObjList l;
		Unit u;
		int i, nCount, min = 40;

		b = set.GetCentralBuilding();
		l = set.ObjectsAround("Military");
		for (i = 0; i < l.count && nCount < min; i += 1) {
			u = l[i].AsUnit();
			if (!b.IsEnemy(u))
				if (!u.IsSentry)
					if (u.inherentlevel < 10) {
						nCount += 1;
						if (u.AsHero().IsValid)//heroes count as 5 units
							nCount += 4;
					}
		}
		if (nCount >= min)
			strTech = "townhall_military_training";
	}
}

if (strTech != "") {
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}