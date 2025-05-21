//void, Settlement set

//called by ES_Stronghold, this script manages researches to improve the army when there is a lot of gold in the stronghold

int AIPlayer, nRace, i;

AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (nRace == Germany || nRace == Carthage)
	if (set.gold >= AIVar(AIPlayer, AIV_SquanderGoldAmount)) {
		Building b;
		str cmd;
		int gold, food;
		point ptDummy;
		Obj objDummy;
		if (nRace == Germany) {//Germany researches are unlimited, so all of them are made twice to increase limits of all advanced units (and food is bought to recruit them)
			int j;
			StrArray germanTechs;
			germanTechs[0] = "Axemen production";
			germanTechs[1] = "Javelin production";
			germanTechs[2] = "Horseshoes production";
			germanTechs[3] = "Macemen production";
			for (i = 0; i < 2; i += 1)
				for (j = 0; j < 4; j += 1) {
					cmd = germanTechs[j];
					if (GetCmdCost(cmd, gold, food)) {
						b = set.FindResearchLab(cmd);
						if (b.IsValid) {
							set.SpentGoldOnTech(gold + food / 2);
							b.ExecCmd(cmd, ptDummy, objDummy, false);
						}
					}
				}
			cmd = "buyfoodforgold";
			if (GetCmdCost(cmd, gold, food)) {
				b = set.FindResearchLab(cmd);
				if (b.IsValid)
					for (i = 0; i < 10; i += 1) {
						set.SpentGoldOnTech(gold + food / 2);
						b.ExecCmd(cmd, ptDummy, objDummy, false);
					}
			}
		}
		else if (nRace == Carthage)
			if (IsResearched(set, "People's Assembly")) {//prepare to train many elephants
				cmd = "Mahout School";
				if (GetCmdCost(cmd, gold, food)) {
					b = set.FindResearchLab(cmd);
					if (b.IsValid)
						for (i = 0; i < 5; i += 1) {
							set.SpentGoldOnTech(gold + food / 2);
							b.ExecCmd(cmd, ptDummy, objDummy, false);
						}
				}
				cmd = "buyfoodforgold";
				if (GetCmdCost(cmd, gold, food)) {
					b = set.FindResearchLab(cmd);
					if (b.IsValid)
						for (i = 0; i < 10; i += 1) {
							set.SpentGoldOnTech(gold + food / 2);
							b.ExecCmd(cmd, ptDummy, objDummy, false);
						}
				}
			}
	}

//Germany is excluded to avoid wasting gold with the risk of never going above the unit limits
if (nRace != Germany)
	if (set.gold >= AIVar(AIPlayer, AIV_ExcessGold)) {
		str strTech;
		if (nRace != Carthage) {//Carthage researches do not work like the others
			int Greece, nType;
			bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;
			StrArray imperialOrPunicOrGreekTechs;

			Greece = ImperialRome;

			if (nRace == RepublicanRome)
				if (IsResearched(set, "ChooseImperialRome"))
					nRaceIsImperialRome = true;
				else if (IsResearched(set, "ChoosePunicRome"))
					nRaceIsPunicRome = true;

			if (nRaceIsImperialRome) {
				imperialOrPunicOrGreekTechs[0] = "";
				imperialOrPunicOrGreekTechs[1] = "Roman Archers";
				imperialOrPunicOrGreekTechs[2] = "Roman Velit";
				imperialOrPunicOrGreekTechs[3] = "Roman Principle";
				imperialOrPunicOrGreekTechs[4] = "Roman Scout";
				imperialOrPunicOrGreekTechs[5] = "Improve Praetorian Equipment";//this is managed in ESH_NeedTech
			}
			else if (nRaceIsPunicRome) {
				imperialOrPunicOrGreekTechs[0] = "";
				imperialOrPunicOrGreekTechs[1] = "Roman Archers";
				imperialOrPunicOrGreekTechs[2] = "Gladiator Shows";
				imperialOrPunicOrGreekTechs[3] = "Roman Principle";
				imperialOrPunicOrGreekTechs[4] = "Roman Scout";
				imperialOrPunicOrGreekTechs[5] = "Roman Praetorian";
			}
			else if (nRace == Greece) {
				imperialOrPunicOrGreekTechs[0] = "";
				imperialOrPunicOrGreekTechs[1] = "Greek Archers";
				imperialOrPunicOrGreekTechs[2] = "Greek Spears";
				imperialOrPunicOrGreekTechs[3] = "Greek Horse Armor";
				imperialOrPunicOrGreekTechs[4] = "Greek Royal Armor";
				imperialOrPunicOrGreekTechs[5] = "Greek Chariot Wheels";
			}

			for (i = 0; i < 6 && strTech == ""; i += 1) {
				nType = EnvReadInt(set, "TechSeq" + AIPlayer + "_" + i);
				if (nType < 0)//end of sequence reached
					break;

				if (nRaceIsImperialRome)
					strTech = imperialOrPunicOrGreekTechs[nType];
				else if (nRaceIsPunicRome)
					strTech = imperialOrPunicOrGreekTechs[nType];
				else if (nRace == Greece)
					strTech = imperialOrPunicOrGreekTechs[nType];
				else
					strTech = UTech(nType, nRace);

				if (strTech == "Gaul Horseman")
					strTech = "Gaul Exceptional Horseshoes";//this is managed in ESH_NeedTech

				if (strTech != "")
					if (!IsResearched(set, strTech))
						break;

				strTech = "";
			}
		}
		else if (!IsResearched(set, "Sacred Legion"))
			strTech = "Sacred Legion";
		if (strTech != "") {
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
		}
	}