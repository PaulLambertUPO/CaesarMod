//void, Settlement set

//called by ES_Stronghold, this script manages researches whose main focus is to improve troops and heroes (special units upgrades are not considered)

int aiPlayer, nRace;
str strTech1, strTech2, strTech3;

aiPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (EnvReadInt(set, "ResearchTrainingComplete") != 1) {
	if (nRace == Gaul) {
		//fights -> battle_tactics -> warrior_tales -> training_1_2_3 -> tavern_items | parallel tavern_items after battle_tactics
		strTech1 = "Fights";
		if (IsResearched(set, strTech1)) {
			strTech1 = "Battle tactics";
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Warrior Tales";
				if (IsResearched(aiPlayer, strTech1)) {
					strTech1 = "Gaul Training 1";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Gaul Training 2";
						if (IsResearched(aiPlayer, strTech1)) {
							strTech1 = "Gaul Training 3";
							if (IsResearched(aiPlayer, strTech1))
								strTech1 = "";
						}
					}
				}
			}
		}

		if (strTech1 == "")
			strTech2 = "Free Beer";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Free Beer";
		else if (rand(3) == 0)
			if (IsResearched(aiPlayer, "Battle tactics"))
				strTech2 = "Free Beer";

		if (strTech2 != "")
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
	else if (nRace == RepublicanRome) {
		if (IsResearched(set, "ChooseRepublicanRome")) {
			//gladiator_shows -> training 1_2 -> nobility -> veteran_offence_health_defence -> God_gift | parallel God_gift after gladiator_shows
			strTech1 = "RGladiator Shows";
			if (IsResearched(set, strTech1)) {
				strTech1 = "Rome Training 1";
				if (IsResearched(aiPlayer, strTech1)) {
					strTech1 = "Rome Training 2";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "RNobility";
						if (IsResearched(aiPlayer, strTech1)) {
							strTech1 = "Veteran Offence";
							if (IsResearched(aiPlayer, strTech1)) {
								strTech1 = "Veteran Health";
								if (IsResearched(aiPlayer, strTech1)) {
									strTech1 = "Veteran Defence";
									if (IsResearched(aiPlayer, strTech1))
										strTech1 = "";
								}
							}
						}
					}
				}
			}

			if (strTech1 == "")
				strTech2 = "Altar of Jupiter";
			else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
				strTech2 = "Altar of Jupiter";
			else if (rand(3) == 0)
				if (IsResearched(set, "RGladiator Shows"))
					strTech2 = "Altar of Jupiter";

			if (strTech2 != "")
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}
		}
		else if (IsResearched(set, "ChooseImperialRome")) {
			//gladiator_shows -> military_academy -> standarditazion_1-2-3 -> God_gift -> import_horses | parallel God_gift after military_academy | parallel import_horses after military_academy
			strTech1 = "RGladiator Shows2";
			if (IsResearched(set, strTech1)) {
				strTech1 = "Military Academy";
				if (IsResearched(set, strTech1)) {
					strTech1 = "Standartization I";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Standartization II";
						if (IsResearched(aiPlayer, strTech1)) {
							strTech1 = "Flexibility";
							if (IsResearched(aiPlayer, strTech1))
								strTech1 = "";
						}
					}
				}
			}

			if (strTech1 == "")
				strTech2 = "Altar of Jupiter";
			else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
				strTech2 = "Altar of Jupiter";
			else if (rand(3) == 0)
				if (IsResearched(set, "Military Academy"))
					strTech2 = "Altar of Jupiter";

			if (strTech2 != "")
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}

			if (strTech1 == "")
				strTech3 = "Free Wine";
			else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
				strTech3 = "Free Wine";
			else if (rand(10) == 0)
				if (IsResearched(set, "Military Academy"))
					strTech3 = "Free Wine";

			if (strTech3 != "")
				if (IsResearched(set, strTech3)) {
					strTech3 = "Import horses";
					if (IsResearched(set, strTech3))
						strTech3 = "";
				}
		}
		else if (IsResearched(set, "ChoosePunicRome")) {
			//gladiator shows -> military_academy -> training_1_2_3 -> God_gift -> import_horses | parallel God_gift after military_academy | parallel import_horses after military_academy
			strTech1 = "Gladiator Shows";
			if (IsResearched(set, strTech1)) {
				strTech1 = "Military Academy";
				if (IsResearched(set, strTech1)) {
					strTech1 = "Training";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Advanced Training";
						if (IsResearched(aiPlayer, strTech1)) {
							strTech1 = "Special training";
							if (IsResearched(aiPlayer, strTech1))
								strTech1 = "";
						}
					}
				}
			}

			if (strTech1 == "")
				strTech2 = "Altar of Jupiter";
			else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
				strTech2 = "Altar of Jupiter";
			else if (rand(3) == 0)
				if (IsResearched(set, "Military Academy"))
					strTech2 = "Altar of Jupiter";

			if (strTech2 != "")
				if (IsResearched(set, strTech2)) {
					strTech2 = "God's Gift";
					if (IsResearched(set, strTech2))
						strTech2 = "";
				}

			if (strTech1 == "")
				strTech3 = "Free Wine";
			else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
				strTech3 = "Free Wine";
			else if (rand(8) == 0)
				if (IsResearched(set, "Military Academy"))
					strTech3 = "Free Wine";

			if (strTech3 != "")
				if (IsResearched(set, strTech3)) {
					strTech3 = "Import horses";
					if (IsResearched(set, strTech3))
						strTech3 = "";
				}
		}
	}
	else if (nRace == Carthage) {
		//people_assembly -> spoils_war -> shared_strength_triumph -> mercenary_pact_heal -> ferocity | parallel mercenary_pact_heal after spoils_war | parallel ferocity after spoils_war
		strTech1 = "People's Assembly";
		if (IsResearched(set, strTech1)) {
			strTech1 = "Spoils of war";
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Shared Strength";
				if (IsResearched(set, strTech1)) {
					strTech1 = "Shared Triumph";
					if (IsResearched(set, strTech1))
						strTech1 = "";
				}
			}
		}

		if (strTech1 == "")
			strTech2 = "Free Trade";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Free Trade";
		else if (rand(2) == 0)
			if (IsResearched(aiPlayer, "Spoils of war"))
				strTech2 = "Free Trade";

		if (strTech2 != "")
			if (IsResearched(set, strTech2)) {
				strTech2 = "Mercenary pact";
				if (IsResearched(aiPlayer, strTech2)) {
					strTech2 = "Mercenary heal";
					if (IsResearched(aiPlayer, strTech2))
						strTech2 = "";
				}
			}

		if (strTech1 == "")
			strTech3 = "Dark Rituals";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech3 = "Dark Rituals";
		else if (rand(8) == 0)
			if (IsResearched(aiPlayer, "Spoils of war"))
				strTech3 = "Dark Rituals";

		if (strTech3 != "")
			if (IsResearched(aiPlayer, strTech3)) {
				strTech3 = "Ferocity";
				if (IsResearched(aiPlayer, strTech3))
					strTech3 = "";
			}
	}
	else if (nRace == Iberia) {
		//tournaments -> heroes_wisdom -> veteran_guild -> nobility -> warriors_wisdom -> ancestral_knowledge -> tame_horses | parallel ancestral_knowledge after heroes_wisdom | parallel tame_horses after heroes_wisdom
		strTech1 = "Tournaments";
		if (IsResearched(set, strTech1)) {
			strTech1 = "Heroes' Wisdom";
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Veteran's guild";
				if (IsResearched(set, strTech1)) {
					strTech1 = "Nobility";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Warriors' Wisdom";
						if (IsResearched(aiPlayer, strTech1))
							strTech1 = "";
					}
				}
			}
		}

		if (strTech1 == "")
			strTech2 = "Code of Valor";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Code of Valor";
		else if (rand(4) == 0)
			if (IsResearched(aiPlayer, "Heroes' Wisdom"))
				strTech2 = "Code of Valor";

		if (strTech2 != "")
			if (IsResearched(aiPlayer, strTech2)) {
				strTech2 = "Ancestral Knowledge";
				if (IsResearched(aiPlayer, strTech2))
					strTech2 = "";
			}

		if (strTech1 == "")
			strTech3 = "Free Drinks";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech3 = "Free Drinks";
		else if (rand(10) == 0)
			if (IsResearched(aiPlayer, "Heroes' Wisdom"))
				strTech3 = "Free Drinks";

		if (strTech3 != "") 
			if (IsResearched(set, strTech3)) {
				strTech3 = "Tame horses";
				if (IsResearched(aiPlayer, strTech3))
					strTech3 = "";
			}
	}
	else if (nRace == Britain) {
		//challenges -> nobility -> nobility_offence_defence -> gambler_day_luck_test -> steel_weapons | parallel gambler_day_luck_test after challenges | parallel steel_weapons after challenges
		strTech1 = "Challenges";
		if (IsResearched(set, strTech1)) {
			strTech1 = "BNobility";
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Noble Offence";
				if (IsResearched(aiPlayer, strTech1)) {
					strTech1 = "Noble Defence";
					if (IsResearched(aiPlayer, strTech1))
						strTech1 = "";
				}
			}
		}

		if (strTech1 == "")
			strTech2 = "Gambling";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Gambling";
		else if (rand(3) == 0)
			if (IsResearched(set, "Challenges"))
				strTech2 = "Gambling";

		if (strTech2 != "")
			if (IsResearched(set, strTech2)) {
				strTech2 = "Gambler's Day";
				if (IsResearched(aiPlayer, strTech2)) {
					strTech2 = "Gambler's Luck";
					if (IsResearched(aiPlayer, strTech2)) {
						strTech2 = "Gambler's Test";
						if (IsResearched(aiPlayer, strTech2))
							strTech2 = "";
					}
				}
			}

		if (strTech1 == "")
			strTech3 = "Steel Weapons";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech3 = "Steel Weapons";
		else if (rand(7) == 0)
			if (IsResearched(aiPlayer, "Challenges"))
				strTech3 = "Steel Weapons";

		if (strTech3 != "")
			if (IsResearched(set, strTech3))
				strTech3 = "";
	}
	else if (nRace == Germany) {
		//tribal fights -> learning -> attack focus -> barbaric tales | tribal fights -> attack focus -> learning -> barbaric tales
		strTech1 = "Tribal fights";
		if (IsResearched(set, strTech1)) {
			if (rand(2) == 0) {
				strTech1 = "Learning";
				if (IsResearched(aiPlayer, strTech1))
					strTech1 = "Attack focus";
			}
			else {
				strTech1 = "Attack focus";
				if (IsResearched(aiPlayer, strTech1))
					strTech1 = "Learning";
			}
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Barbaric Tales";
				if (IsResearched(aiPlayer, strTech1))
					strTech1 = "";
			}
		}
	}
	else if (nRace == ImperialRome) {//Greece
		//olympic_games -> government -> spartan_training -> charm_Athena_Aegle -> military_preparation -> statue_Zeus | parallel statue_Zeus after spartan_training
		strTech1 = "Olympic Games";
		if (IsResearched(set, strTech1)) {
			str governmentForm;
			governmentForm = EnvReadString(aiPlayer, "GovernmentForm");
			if (governmentForm != "Democracy")
				if (governmentForm != "Oligarchy")
					if (rand(3) == 0)
						strTech1 = "Oligarchy";
					else
						strTech1 = "Democracy";//democracy has a higher chance to be chosen because it is easier to use
			if (strTech1 == "Olympic Games") {
				strTech1 = "Spartan Training";
				if (IsResearched(aiPlayer, strTech1)) {
					strTech1 = "Charm of Athena";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Charm of Aegle";
						if (IsResearched(aiPlayer, strTech1)) {
							strTech1 = "Military Preparation";
							if (IsResearched(set, strTech1))
								strTech1 = "";
						}
					}
				}
			}
		}

		if (strTech1 == "")
			strTech2 = "Offer to Gods";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Offer to Gods";
		else if (rand(5) == 0)
			if (IsResearched(aiPlayer, "Spartan Training"))
				strTech2 = "Offer to Gods";

		if (strTech2 != "")
			if (IsResearched(set, strTech2)) {
				strTech2 = "Statue of Zeus";
				if (IsResearched(aiPlayer, strTech2))
					strTech2 = "";
			}
	}
	else if (nRace == Egypt) {
		//cult_Anubis -> path_dead_1_2_3 -> cult_Horus -> statue_AmonRa_Osiris_Isis -> light_Horus_1_2_3 -> mumification | parallel mumification after statue_AmonRa
		strTech1 = "Cult of Anubis";
		if (IsResearched(set, strTech1)) {
			strTech1 = "Path of the dead I";
			if (IsResearched(aiPlayer, strTech1)) {
				strTech1 = "Path of the dead II";
				if (IsResearched(aiPlayer, strTech1)) {
					strTech1 = "Path of the dead III";
					if (IsResearched(aiPlayer, strTech1)) {
						strTech1 = "Cult of Horus";
						if (IsResearched(set, strTech1)) {
							strTech1 = "Statue of Amon-Ra";
							if (IsResearched(aiPlayer, strTech1)) {
								strTech1 = "Statue of Osiris";
								if (IsResearched(aiPlayer, strTech1)) {
									strTech1 = "Statue of Isis";
									if (IsResearched(aiPlayer, strTech1)) {
										strTech1 = "Light of Horus I";
										if (IsResearched(set, strTech1)) {
											strTech1 = "Light of Horus II";
											if (IsResearched(set, strTech1)) {
												strTech1 = "Light of Horus III";
												if (IsResearched(set, strTech1))
													strTech1 = "";
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

		if (strTech1 == "")
			strTech2 = "Cult of Osiris";
		else if (set.gold >= AIVar(aiPlayer, AIV_ExcessGold))
			strTech2 = "Cult of Osiris";
		else if (rand(6) == 0)
			if (IsResearched(aiPlayer, "Statue of Amon-Ra"))
				strTech2 = "Cult of Osiris";

		if (strTech2 != "")
			if (IsResearched(set, strTech2)) {
				strTech2 = "Mumification";
				if (IsResearched(aiPlayer, strTech2))
					strTech2 = "";
			}
	}

	//parallel researches
	if (strTech2 == "")
		strTech2 = strTech3;
	else {
		EnvWriteString(set, "strTech", strTech3);
		set.AIRun("ESH_NeedTech.vs");
	}
	if (strTech1 == "")
		strTech1 = strTech2;
	else {
		EnvWriteString(set, "strTech", strTech2);
		set.AIRun("ESH_NeedTech.vs");
	}

	//when everything has been researched, unlock the execution of the other scripts and avoid checking every tech again and again
	if (strTech1 == "")
		EnvWriteInt(set, "ResearchTrainingComplete", 1);
}

//research additional repeatable upgrades
if (nRace == Egypt) {
	bool getCharms = false;
	if (set.gold >= AIVar(aiPlayer, AIV_SquanderGoldAmount))
		getCharms = true;
	else if (strTech1 == "")
		if (rand(5) == 0)
			if (set.gold >= 2000)
				getCharms = true;
	if (getCharms) {
		Building b;
		ObjList l;
		Obj o;
		StrArray items, techs;
		int i, j, count_units;
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
		for (i = l.count - 1; i >= 0; i -= 1) {
			o = l[i];
			if (o.IsAlive)
				if (!b.IsEnemy(o))
					if (o.free_item_slots > 0)
						if (!o.HasItem(charm))
							if (!o.IsSentry)
								if (!o.AsHero().IsValid) {
									count_units += 1;
									if (count_units >= 30) {
										strTech1 = techs[j];
										break;
									}
								}
		}
	}
}
else if (nRace == RepublicanRome || nRace == Carthage || nRace == Germany) {
	bool townTraining = false;
	if (set.gold >= AIVar(aiPlayer, AIV_SquanderGoldAmount))
		townTraining = true;
	else if (strTech1 == "")
		if (rand(5) == 0)
			if (set.gold >= 3500)
				townTraining = true;
	if (townTraining) {
		Building b;
		ObjList l;
		Obj o;
		int i, count_units;

		b = set.GetCentralBuilding();
		l = set.ObjectsAround("Military");
		for (i = l.count - 1; i >= 0; i -= 1) {
			o = l[i];
			if (!b.IsEnemy(o))
				if (!o.IsSentry)
					if (o.AsUnit().inherentlevel < 10) {
						count_units += 1;
						if (o.AsHero().IsValid)//heroes count as 10 units
							count_units += 9;
						if (count_units >= 40) {
							strTech1 = "military_training";
							break;
						}
					}
		}
	}
}

if (strTech1 != "") {
	EnvWriteString(set, "strTech", strTech1);
	set.AIRun("ESH_NeedTech.vs");
}