//void, Settlement set

//called by ES_Stronghold, this script manages arena units and their specific researches
//be careful: research commands to be issued to the settlement sometimes have different names from what they set in the player/settlement environment

int Greece, AIPlayer, nRace, max, nMaxAllowed, nCallCount = 1, upgrade_units, gold, food;
bool nRaceIsRepublicanRome = false, nRaceIsImperialRome = false, nRaceIsPunicRome = false;
str strTech, strHire, class;
int nArenaResearchLevel;//0 - no upgrades, 1 - first, 2 - important
int nUpgradeType;//0 - no upgrades, 1 - player, 2 - settlement

Greece = ImperialRome;
AIPlayer = set.player;
nRace = set.GetCentralBuilding().race;

if (nRace == RepublicanRome)
	if (IsResearched(set, "ChooseRepublicanRome"))
		nRaceIsRepublicanRome = true;
	else if (IsResearched(set, "ChooseImperialRome"))
		nRaceIsImperialRome = true;
	else
		nRaceIsPunicRome = true;

nArenaResearchLevel = EnvReadInt(set, "ArenaResearchLevel");

//first upgrade
if (nArenaResearchLevel < 1) {
	if (nRace == Gaul)
		strTech = "Fights";
	else if (nRaceIsRepublicanRome)
		strTech = "Roman Chariot Wheels";
	else if (nRaceIsImperialRome)
		strTech = "RGladiator Shows2";
	else if (nRaceIsPunicRome)
		strTech = "Gladiator Shows";
	else if (nRace == Carthage)
		strTech = "People's Assembly";
	else if (nRace == Iberia)
		strTech = "Tournaments";
	else if (nRace == Britain)
		strTech = "Britain Fights";
	else if (nRace == Egypt)
		strTech = "Cult of Osiris";
	else if (nRace == Germany)
		strTech = "TFights";
	else if (nRace == Greece)
		strTech = "Olympic Games";
	if (!IsResearched(set, strTech)) {
		EnvWriteString(set, "strTech", strTech);
		set.AIRun("ESH_NeedTech.vs");
		return;
	}
	nArenaResearchLevel = 1;
	EnvWriteInt(set, "ArenaResearchLevel", nArenaResearchLevel);
}

//count arena units
if (nRace == Gaul) {
	strHire = "Hire Trident warrior";
	class = "GTridentWarrior";
	max = 6;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxGTridentWarrior);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Trident Warrior Exp1";
}
else if (nRaceIsRepublicanRome) {
	strHire = "Equip Chariot";
	class = "RChariot";
	max = 15;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxRChariot);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
}
else if (nRaceIsImperialRome) {
	strHire = "Hire Liberati";
	class = "RLiberatus";
	nCallCount = 10;
	max = 20;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxRLiberati);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Liberati guild";
}
else if (nRaceIsPunicRome) {
	strHire = "Hire Liberati Punic";
	class = "RLiberatus";//do not use RLiberatusPunic otherwise Count below might give a wrong result
	nCallCount = 10;
	max = 20;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxRLiberati);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Liberati guild";
}
else if (nRace == Carthage) {
	strHire = "Train War Elephant";
	class = "CWarElephant";
	max = EnvReadInt(AIPlayer, "MaxElephants") + 1;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxCWarElephant);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Mahout Mastery";
}
else if (nRace == Iberia) {
	strHire = "Call Mountaineer";
	class = "IMountaineer";
	max = 10;
	if (IsResearched(AIPlayer, "Mountain Clan"))
		max = 20;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxIMountaineers);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 1;
	strTech = "Mountain Clan";
}
else if (nRace == Britain) {
	strHire = "Hire Viking Lord";
	class = "BVikingLord";
	max = 6;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxBVikingLord);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Shrine of Thor";
}
else if (nRace == Egypt) {
	strHire = "Chariot of Osiris";
	class = "EChariot";
	max = 15;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxEChariot);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
}
else if (nRace == Germany) {
	strHire = "Call Valkyries";
	class = "TValkyrie";
	nCallCount = 5;
	max = 10;
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxTValkyrie);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	nUpgradeType = 2;
	strTech = "Legendary Valkyries";
}
else if (nRace == Greece) {
	strHire = "trainHMyrmidon";
	class = "HMyrmidon_Javelin";
	max = EnvReadInt(AIPlayer, "MaxMyrmidons");
	nMaxAllowed	= AIVar(AIPlayer, AIV_MaxHMyrmidon);
	if (nMaxAllowed >= 0)
		if (nMaxAllowed < max)
			max = nMaxAllowed;
	max = MIN(max, GetConst("MaxMyrmidonsValue"));
	nUpgradeType = 1;
	strTech = "Tribute to Heracles";
}

//decide whether to upgrade units
upgrade_units = AIVar(AIPlayer, AIV_ArenaUpgradeHires);//0 - easy, 1 - normal, -1 - hard
if (upgrade_units == 0)
	nArenaResearchLevel = 2;
else if (nArenaResearchLevel < 2)
	if (nUpgradeType == 1) {//player upgrades (Iberia and Greece)
		if (nRace == Iberia)
			if (IsResearched(AIPlayer, strTech))
				strTech = "Mountain Clan Legacy";
		if (IsResearched(AIPlayer, strTech))
			nArenaResearchLevel = 2;
		else {
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			if (upgrade_units < 0)
				return;
			if (IsResearching(set, strTech))
				return;
		}
	}
	else if (nUpgradeType == 2) {//settlement upgrades (Gaul, Imperial/Punic Rome, Carthage, Britain and Germany)
		if (nRace == Gaul)
			if (IsResearched(set, strTech)) {
				strTech = "Trident Warrior Exp2";
				if (IsResearched(set, strTech))
					strTech = "Trident Warrior Exp3";
			}
		if (IsResearched(set, strTech))
			nArenaResearchLevel = 2;
		else {
			EnvWriteString(set, "strTech", strTech);
			set.AIRun("ESH_NeedTech.vs");
			if (upgrade_units < 0)
				return;
			if (IsResearching(set, strTech))
				return;
		}
	}
	else
		nArenaResearchLevel = 2;//no further upgrades (Republican Rome and Egypt)

EnvWriteInt(set, "ArenaResearchLevel", nArenaResearchLevel);

if (Count(AIPlayer, class) + nCallCount <= max) {
	if (!GetCmdCost(strHire, gold, food))
		return;
	if (nRace == Carthage)
		if (set.food - food < MIN(500, EnvReadInt(set, "nFoodReserve") / 2))
			return;
	EnvWriteString(set, "strTech", strHire);
	set.AIRun("ESH_NeedTech.vs");
	return;
}

//this part is executed only when all upgrades have been researched (unless AIV_ArenaUpgradeHires is 0) and the unit limit has been reached
if (nArenaResearchLevel == 2) {
	//upgrades to either further improve units (Imperial Rome) or increase their limit (Carthage and Greece)
	if (upgrade_units != 0)
		if (nRaceIsImperialRome) {
			if (!IsResearched(AIPlayer, "Liberati triumph")) {
				EnvWriteString(set, "strTech", "Liberati triumph");
				set.AIRun("ESH_NeedTech.vs");
				return;
			}
		}
		else if (nRace == Carthage) {
			if (nMaxAllowed < 0 || max < nMaxAllowed)
				if (set.CanAfford(strHire)) {
					EnvWriteString(set, "strTech", "Mahout School");
					set.AIRun("ESH_NeedTech.vs");
					return;
				}
		}
		else if (nRace == Greece)
			if (nMaxAllowed < 0 || max < nMaxAllowed)
				if (set.CanAfford(strHire)) {
					EnvWriteString(set, "strTech", "Forge Elite Equipment");
					set.AIRun("ESH_NeedTech.vs");
					return;
				}
	//supreme heroes (Gaul and Republican Rome)
	if (AIVar(AIPlayer, AIV_SupremeHeroes) != 0) {
		class = "";
		if (nRace == Gaul) {
			if (GetTime() >= 2700000)
				if (IsResearched(AIPlayer, "Special training"))
					if (IsResearched(set, "Trident Warrior Exp3"))
						if (IsResearched(AIPlayer, "Warrior Tales"))
							if (IsResearched(AIPlayer, "Battle tactics"))
								if (IsResearched(set, "Legendary Heroes")) {
									if (rand(2) == 0) {
										strHire = "Hire Keltill";
										class = "Keltill";
										if (Count(AIPlayer, class) >= 1) {
											strHire = "Hire Larax";
											class = "Larax";
										}
									}
									else {
										strHire = "Hire Larax";
										class = "Larax";
										if (Count(AIPlayer, class) >= 1) {
											strHire = "Hire Keltill";
											class = "Keltill";
										}
									}
								}
								else {
									EnvWriteString(set, "strTech", "Legendary Heroes");
									set.AIRun("ESH_NeedTech.vs");
								}
		}
		else if (nRaceIsRepublicanRome)
			if (GetTime() >= 2400000)
				if (IsResearched(AIPlayer, "Advanced Training"))
					if (IsResearched(AIPlayer, "Veteran Offence"))
						if (IsResearched(AIPlayer, "Veteran Defence"))
							if (IsResearched(AIPlayer, "Veteran Health"))
								if (IsResearched(AIPlayer, "Nobility"))
									if (IsResearched(set, "Transition to Empire")) {
										strHire = "Hire Caesar";
										class = "Caesar";
									}
									else {
										EnvWriteString(set, "strTech", "Transition to Empire");
										set.AIRun("ESH_NeedTech.vs");
									}
		if (class != "")
			if (Count(AIPlayer, class) < 1)
				if (set.CanResearch(strHire) && set.CanAfford(strHire)) {
					GetCmdCost(strHire, gold, food);
					set.SpentGoldOnArmy(gold + food / 2);
					set.Research(strHire);
				}
				else {
					int budget;
					budget = AIVar(AIPlayer, AIV_TechBudget);//save original value
					SetAIVar(AIPlayer, AIV_TechBudget, 100);
					set.StopReserving();
					EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
					EnvWriteString(set, "strTech", strHire);
					set.AIRun("ESH_NeedTech.vs");
					SetAIVar(AIPlayer, AIV_TechBudget, budget);//restore budget
				}
	}
}