//void, Settlement set

//called by ES_Stronghold, this script decides a sequence of researches to unlock advanced units

int aiPlayer, nRace, i, j, k;
StrArray imperialOrPunicOrGreekTechs;
IntArray randoms;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;

aiPlayer = set.player;
nRace = set.GetCentralBuilding().race;

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
	imperialOrPunicOrGreekTechs[5] = "Spiked armor II";
}
else if (nRaceIsPunicRome) {
	imperialOrPunicOrGreekTechs[0] = "";
	imperialOrPunicOrGreekTechs[1] = "Roman Archers";
	imperialOrPunicOrGreekTechs[2] = "Gladiator Shows";
	imperialOrPunicOrGreekTechs[3] = "Roman Principle";
	imperialOrPunicOrGreekTechs[4] = "Roman Scout";
	imperialOrPunicOrGreekTechs[5] = "Spiked armor";
}
else if (nRace == ImperialRome) {//Greece
	imperialOrPunicOrGreekTechs[0] = "";
	imperialOrPunicOrGreekTechs[1] = "Greek Archers";
	imperialOrPunicOrGreekTechs[2] = "Greek Spears";
	imperialOrPunicOrGreekTechs[3] = "Greek Horse Armor";
	imperialOrPunicOrGreekTechs[4] = "Greek Royal Armor";
	imperialOrPunicOrGreekTechs[5] = "Greek Chariot Wheels";
}

for (i = 0; i < 6; i += 1)
	randoms[i] = i;

//shuffle
for (i = 0; i < 10; i += 1) {
	j = rand(5);
	k = randoms[j];
	randoms[j] = randoms[j + 1];
	randoms[j + 1] = k;
}

//remove disabled or not needed techs (CHorseman is not managed here, but that is not a problem because this script is not used for Carthage/Germany stronghold)
j = 0;
for (i = 0; i < 6; i += 1)
	if (nRaceIsImperialRome) {
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[j] = randoms[i];
			j += 1;
		}
	}
	else if (nRaceIsPunicRome) {
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[j] = randoms[i];
			j += 1;
		}
	}
	else if (nRace == ImperialRome) {//Greece
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[j] = randoms[i];
			j += 1;
		}
	}
	else if (UTech(randoms[i], nRace) != "") {
		randoms[j] = randoms[i];
		j += 1;
	}

randoms[j] = -1;//anything starting from -1 is not to be considered

for (i = 0; i <= j; i += 1)
	EnvWriteInt(set, "TechSeq" + aiPlayer + "_" + i, randoms[i]);

EnvWriteInt(set, "TechSeq" + aiPlayer + "_Initted", 1);