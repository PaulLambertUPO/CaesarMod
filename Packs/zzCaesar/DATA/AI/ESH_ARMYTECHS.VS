//void, Settlement set

//called by ES_Stronghold, this script manages researches to unlock more units for the army

int nRace;
str strTech;

nRace = set.GetCentralBuilding().race;

if (nRace == Carthage) {//Carthage researches are managed in ESH_BuildCarthaginianArmy, so only sacred legion is considered here
	if (!IsResearched(set, "Sacred Legion"))
		strTech = "Sacred Legion";
}
else if (nRace == Germany) {//Germany researches are mainly managed in ESH_BuildGermanArmy
	if (rand(10) == 0)
		if (set.gold >= AIVar(set.player, AIV_ExcessGold)) {
			StrArray germanTechs;

			germanTechs[0] = "Axe production";
			germanTechs[1] = "Javelin production";
			germanTechs[2] = "Horseshoe production";
			germanTechs[3] = "Mace production";

			strTech = germanTechs[rand(4)];
		}
}
else {
	int aiPlayer, nType, i;
	bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;
	StrArray imperialOrPunicOrGreekTechs;

	aiPlayer = set.player;

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
	else if (nRace == ImperialRome) {//Greece
		imperialOrPunicOrGreekTechs[0] = "";
		imperialOrPunicOrGreekTechs[1] = "Greek Archers";
		imperialOrPunicOrGreekTechs[2] = "Greek Spears";
		imperialOrPunicOrGreekTechs[3] = "Greek Horse Armor";
		imperialOrPunicOrGreekTechs[4] = "Greek Royal Armor";
		imperialOrPunicOrGreekTechs[5] = "Greek Chariot Wheels";
	}

	for (i = 0; i < 6; i += 1) {
		nType = EnvReadInt(set, "TechSeq" + aiPlayer + "_" + i);
		if (nType < 0)//end of sequence reached
			break;

		if (nRaceIsImperialRome)
			strTech = imperialOrPunicOrGreekTechs[nType];
		else if (nRaceIsPunicRome)
			strTech = imperialOrPunicOrGreekTechs[nType];
		else if (nRace == ImperialRome)//Greece
			strTech = imperialOrPunicOrGreekTechs[nType];
		else
			strTech = UTech(nType, nRace);

		if (strTech == "Gaul Horseman")
			strTech = "Gaul Exceptional Horseshoes";//this is managed in ESH_NeedTech

		if (strTech != "")
			if (!IsResearched(set, strTech))
				break;
	}
}

if (strTech != "") {
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}