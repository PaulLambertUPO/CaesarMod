//void, Settlement set

//called by ES_Stronghold, this script manages researches mainly focused on magic powers

int aiPlayer, nRaceAvail;//the strange name is to save some memory
str strTech;

aiPlayer = set.player;
nRaceAvail = set.GetCentralBuilding().race;

//upgrades that do not have focus on sages
if (nRaceAvail == RepublicanRome) {
	if (IsResearched(set, "Altar of Jupiter"))
		if (!IsResearched(set, "God's Gift"))
			if (rand(5) == 0)
				strTech = "God's Gift";
			else if (set.gold >= 2500)
				strTech = "God's Gift";
}
else if (nRaceAvail == ImperialRome) {//Greece
	if (IsResearched(set, "Offer to Gods"))
		if (!IsResearched(aiPlayer, "Statue of Zeus"))
			if (rand(5) == 0)
				strTech = "Statue of Zeus";
			else if (set.gold >= 3000)
				strTech = "Statue of Zeus";
}
else if (nRaceAvail == Carthage) {
	if (IsResearched(aiPlayer, "Dark Rituals"))
		if (!IsResearched(aiPlayer, "Ferocity"))
			if (rand(5) == 0)
				strTech = "Ferocity";
			else if (set.gold >= 3500)
				strTech = "Ferocity";
}
else if (nRaceAvail == Egypt) {
	if (IsResearched(set, "Cult of Osiris"))
		if (!IsResearched(aiPlayer, "Mumification"))
			if (rand(5) == 0)
				strTech = "Mumification";
			if (set.gold >= 3500)
				strTech = "Mumification";
}

if (strTech == "") {
	if (nRaceAvail == Gaul) {
		strTech = "Ritual Chamber";
		if (IsResearched(aiPlayer, strTech)) {
			strTech = "Reincarnation Ritual";
			if (IsResearched(aiPlayer, strTech)) {
				strTech = "Restoration";
				if (IsResearched(aiPlayer, strTech))
					return;
			}
		}
		nRaceAvail = Count(aiPlayer, "GDruid");
	}
	else if (nRaceAvail == RepublicanRome) {
		strTech = "Altar of Jupiter";
		if (IsResearched(set, strTech)) {
			strTech = "Wrath of Jupiter";
			if (IsResearched(aiPlayer, strTech))
				return;
		}
		nRaceAvail = Count(aiPlayer, "RPriest");
	}
	else if (nRaceAvail == ImperialRome) {//Greece
		strTech = "Offer to Gods";
		if (IsResearched(set, strTech)) {
			strTech = "HRestoration";
			if (IsResearched(aiPlayer, strTech))
				return;
		}
		nRaceAvail = Count(aiPlayer, "HPriest");
	}
	else if (nRaceAvail == Carthage) {
		strTech = "Dark Rituals";
		if (IsResearched(aiPlayer, strTech)) {
			strTech = "Zombify";
			if (IsResearched(aiPlayer, strTech))
				return;
		}
		nRaceAvail = Count(aiPlayer, "CShaman");
	}
	else if (nRaceAvail == Iberia) {
		strTech = "Code of Valor";
		if (IsResearched(set, strTech)) {
			strTech = "Cover of Mercy";
			if (IsResearched(aiPlayer, strTech)) {
				strTech = "IRestoration";
				if (IsResearched(aiPlayer, strTech))
					return;
			}
		}
		nRaceAvail = Count(aiPlayer, "IEnchantress");
		if (!IsResearched(aiPlayer, "Cover of Mercy"))
			nRaceAvail = 3 * nRaceAvail;//boost combat upgrades priority because enchantresses can "only" train units
	}
	else if (nRaceAvail == Britain) {
		strTech = "Britain chamber";
		if (IsResearched(aiPlayer, strTech)) {
			strTech = "Mass Heal";
			if (IsResearched(aiPlayer, strTech)) {
				strTech = "Mass Invisibility";
				if (IsResearched(aiPlayer, strTech))
					return;
			}
		}
		nRaceAvail = Count(aiPlayer, "BDruid");
		if (!IsResearched(aiPlayer, "Mass Heal"))
			nRaceAvail = 3 * nRaceAvail;//boost combat upgrades priority because Britain druids can "only" hide units
	}
	else if (nRaceAvail == Egypt) {
		strTech = "Cult of Osiris";
		if (IsResearched(set, strTech)) {
			strTech = "EZombify";
			if (IsResearched(aiPlayer, strTech))
				return;
		}
		nRaceAvail = Count(aiPlayer, "EPriest");
	}
	else if (nRaceAvail == Germany) {
		strTech = "German chamber";
		if (IsResearched(aiPlayer, strTech)) {
			strTech = "German Mass Heal";
			if (IsResearched(aiPlayer, strTech))
				return;
		}
		nRaceAvail = Count(aiPlayer, "TEnchantress");
	}

	if (nRaceAvail < AIVar(aiPlayer, AIV_CombatMagic))
		if (set.gold < AIVar(aiPlayer, AIV_SquanderGoldAmount))
			return;
}

if (strTech != "") {
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}