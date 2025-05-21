//void, Settlement set

//called by ES_Stronghold, this script manages researches mainly focused on magic powers
//note that research commands to be issued to the settlement sometimes have different names from what they set in the player/settlement environment

int Greece, AIPlayer, nRace;
str strTech;

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

//upgrades that do not have focus on magic units
if (nRace == RepublicanRome) {
	if (IsResearched(set, "Altar of Jupiter"))
		if (!IsResearched(set, "God's Gift"))
			if (rand(5) == 0)
				strTech = "God's Gift";
			else if (set.gold >= 2500)
				strTech = "God's Gift";
}
else if (nRace == Greece) {
	if (IsResearched(set, "Offer to Gods"))
		if (!IsResearched(AIPlayer, "Statue of Zeus"))
			if (rand(5) == 0)
				strTech = "Statue of Zeus";
			else if (set.gold >= 3000)
				strTech = "Statue of Zeus";
}
else if (nRace == Carthage) {
	if (IsResearched(set, "Dark Rituals"))
		if (!IsResearched(AIPlayer, "Ferocity"))
			if (rand(5) == 0)
				strTech = "Ferocity";
			else if (set.gold >= 3500)
				strTech = "Ferocity";
}
else if (nRace == Egypt) {
	if (IsResearched(set, "Cult of Osiris"))
		if (!IsResearched(AIPlayer, "Mumification"))
			if (rand(5) == 0)
				strTech = "Mumification";
			if (set.gold >= 3500)
				strTech = "Mumification";
}

if (strTech == "") {
	int nAvail;
	if (nRace == Gaul) {
		strTech = "Ritual Chamber";
		if (IsResearched(AIPlayer, strTech)) {
			strTech = "Reincarnation Ritual";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Restoration";
				if (IsResearched(AIPlayer, strTech))
					return;
			}
		}
		nAvail = Count(AIPlayer, "GDruid");
	}
	else if (nRace == RepublicanRome) {
		strTech = "Altar of Jupiter";
		if (IsResearched(set, strTech)) {
			strTech = "Wrath of Jupiter";
			if (IsResearched(AIPlayer, strTech))
				return;
		}
		nAvail = Count(AIPlayer, "RPriest");
	}
	else if (nRace == Greece) {
		strTech = "Offer to Gods";
		if (IsResearched(set, strTech)) {
			strTech = "HRestoration";
			if (IsResearched(AIPlayer, "Restoration"))
				return;
		}
		nAvail = Count(AIPlayer, "HPriest");
	}
	else if (nRace == Carthage) {
		strTech = "Dark Rituals";
		if (IsResearched(set, strTech)) {
			strTech = "Zombify";
			if (IsResearched(AIPlayer, strTech))
				return;
		}
		nAvail = Count(AIPlayer, "CShaman");
	}
	else if (nRace == Iberia) {
		strTech = "Code of Valor";
		if (IsResearched(set, strTech)) {
			strTech = "Cover of Mercy";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "IRestoration";
				if (IsResearched(AIPlayer, "Restoration"))
					return;
			}
		}
		nAvail = Count(AIPlayer, "IEnchantress");
		if (!IsResearched(AIPlayer, "Cover of Mercy"))
			nAvail = 3 * nAvail;//boost combat upgrades priority because enchantresses can "only" train units
	}
	else if (nRace == Britain) {
		strTech = "Britain chamber";
		if (IsResearched(AIPlayer, "Ritual Chamber")) {
			strTech = "Mass Heal";
			if (IsResearched(AIPlayer, strTech)) {
				strTech = "Mass Concealment";
				if (IsResearched(AIPlayer, strTech))
					return;
			}
		}
		nAvail = Count(AIPlayer, "BDruid");
		if (!IsResearched(AIPlayer, "Mass Heal"))
			nAvail = 3 * nAvail;//boost combat upgrades priority because Britain druids can "only" hide units
	}
	else if (nRace == Egypt) {
		strTech = "Cult of Osiris";
		if (IsResearched(set, strTech)) {
			strTech = "EZombify";
			if (IsResearched(AIPlayer, "Zombify"))
				return;
		}
		nAvail = Count(AIPlayer, "EPriest");
	}
	else if (nRace == Germany) {
		strTech = "German chamber";
		if (IsResearched(AIPlayer, "Ritual Chamber")) {
			strTech = "German Mass Heal";
			if (IsResearched(AIPlayer, "Mass Heal"))
				return;
		}
		nAvail = Count(AIPlayer, "TEnchantress");
	}

	if (nAvail < AIVar(AIPlayer, AIV_CombatMagic))
		if (set.gold < AIVar(AIPlayer, AIV_SquanderGoldAmount))
			return;
}

if (strTech != "") {
	EnvWriteString(set, "strTech", strTech);
	set.AIRun("ESH_NeedTech.vs");
}