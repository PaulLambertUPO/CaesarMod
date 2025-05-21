//void, Settlement set

//called by ES_Stronghold, this script decides a sequence of researches to unlock advanced units

int Greece, AIPlayer, nRace, i, a, b, count;
StrArray imperialOrPunicOrGreekTechs;
IntArray randoms;
bool nRaceIsImperialRome = false, nRaceIsPunicRome = false;

Greece = ImperialRome;
AIPlayer = set.player;
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
	imperialOrPunicOrGreekTechs[5] = "Roman Praetorian";
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

for (i = 0; i < 6; i += 1)
	randoms[i] = i;

//scramble
for (i = 0; i < 10; i += 1) {
	a = rand(5);
	b = randoms[a];
	randoms[a] = randoms[a + 1];
	randoms[a + 1] = b;
}

//remove disabled or not needed techs (CHorseman is not managed here, but that is not a problem because this script is not used for Carthage/Germany stronghold)
for (i = 0; i < 6; i += 1)
	if (nRaceIsImperialRome) {
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[count] = randoms[i];
			count += 1;
		}
	}
	else if (nRaceIsPunicRome) {
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[count] = randoms[i];
			count += 1;
		}
	}
	else if (nRace == Greece) {
		if (imperialOrPunicOrGreekTechs[randoms[i]] != "") {
			randoms[count] = randoms[i];
			count += 1;
		}
	}
	else if (UTech(randoms[i], nRace) != "") {
		randoms[count] = randoms[i];
		count += 1;
	}

randoms[count] = -1;//anything starting from -1 is not to be considered

for (i = 0; i < count; i += 1)
	EnvWriteInt(set, "TechSeq" + AIPlayer + "_" + i, randoms[i]);

EnvWriteInt(set, "TechSeq" + AIPlayer + "_Initted", 1);