//void, Settlement set

//be careful: research commands to be issued to the settlement sometimes have different names from what they set in the player/settlement environment

str strTech;

strTech = EnvReadString(set, "strTech");

//this check avoids a bug where AI hires too many Valkyries/Liberati (ESH_ArenaUnits -> 4 Valkyries -> ExecCmd -> 1/5 spawns -> check 5 + 5 <= 10 -> ExecCmd -> 14 Valkyries)
if (strTech == "Call Valkyries") {
	if (GetTime() < EnvReadInt(set, "TimeToAvoidExcessTroops"))
		return;
}
else if (strTech == "Hire Liberati") {
	if (GetTime() < EnvReadInt(set, "TimeToAvoidExcessTroops"))
		return;
}
else if (strTech == "Hire Liberati Punic")
	if (GetTime() < EnvReadInt(set, "TimeToAvoidExcessTroops"))
		return;

if (strTech != "") {
	bool bArenaHire = false;

	if (strTech == "Hire Trident warrior")
		bArenaHire = true;
	else if (strTech == "Hire Liberati")
		bArenaHire = true;
	else if (strTech == "Hire Liberati Punic")
		bArenaHire = true;
	else if (strTech == "Equip Chariot")
		bArenaHire = true;
	else if (strTech == "Hire Viking Lord")
		bArenaHire = true;
	else if (strTech == "Call Mountaineer")
		bArenaHire = true;
	else if (strTech == "Chariot of Osiris")
		bArenaHire = true;
	else if (strTech == "Call Valkyries")
		bArenaHire = true;
	else if (strTech == "trainHMyrmidon")
		bArenaHire = true;
	else if (strTech == "Train War Elephant")
		bArenaHire = true;
	else if (strTech == "Hire Caesar")
		bArenaHire = true;
	else if (strTech == "Hire Keltill")
		bArenaHire = true;
	else if (strTech == "Hire Larax")
		bArenaHire = true;

	if (bArenaHire || GetTime() >= EnvReadInt(set, "ResearchTechTime")) {
		int AIPlayer, nRace, gold, food;
		bool bPossibleDiscard = false;

		AIPlayer = set.player;
		nRace = set.GetCentralBuilding().race;

		if (nRace == Carthage) {
			if (strTech == "Sacred Legion")
				if (!IsResearched(set, "Dark Rituals"))
					strTech = "Dark Rituals";
		}
		else if (nRace == Gaul) {
			if (strTech == "Gaul Iron Axes") {
				if (!IsResearched(set, "Gaul Axeman"))
					strTech = "Gaul Axeman";
			}
			else if (strTech == "Gaul Iron Spearheads") {
				if (!IsResearched(set, "Gaul Spearman"))
					strTech = "Gaul Spearman";
			}
			else if (strTech == "Gaul Exceptional Horseshoes") {
				if (!IsResearched(set, "Gaul Horseman"))
					strTech = "Gaul Horseman";
			}
			else if (strTech == "Gaul Fine Armor")
				if (!IsResearched(set, "Gaul Woman Warrior"))
					strTech = "Gaul Woman Warrior";
		}
		else if (nRace == RepublicanRome)
			if (IsResearched(set, "ChooseImperialRome"))
				if (strTech == "Improve Praetorian Equipment")
					if (!IsResearched(set, "Roman Praetorian"))
						strTech = "Roman Praetorian";

		if (IsResearched(AIPlayer, strTech))
			bPossibleDiscard = true;
		else if (IsResearched(set, strTech))
			bPossibleDiscard = true;
		else if (IsResearching(set, strTech))
			bPossibleDiscard = true;
		else if (!GetCmdCost(strTech, gold, food))
			bPossibleDiscard = true;

		if (bPossibleDiscard) {
			if (strTech == EnvReadString(set, "ReserveFor" + (AIPlayer - 1))) {
				set.StopReserving();
				EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
				EnvWriteInt(set, "ReserveCounter", 0);
			}
			EnvWriteInt(set, "FreezeArmyBuild", 0);
			return;
		}

		if (set.CanResearch(strTech)) {
			bool bReserving = false;

			//if there is a huge amount of needed resources in the fortress, there is no reason to discard tech research
			if (gold > 0)
				if (set.gold < AIVar(AIPlayer, AIV_SquanderGoldAmount))
					bPossibleDiscard = true;
			if (!bPossibleDiscard)
				if (food > 0)
					if (set.food < AIVar(AIPlayer, AIV_SquanderFoodAmount))
						bPossibleDiscard = true;

			//if possible to discard, check reservation
			if (bPossibleDiscard) {
				str strReserving;
				strReserving = EnvReadString(set, "ReserveFor" + (AIPlayer - 1));
				if (strReserving != "")
					if (strReserving == strTech) {//if there is one for the needed tech, refresh the counter
						bReserving = true;
						EnvWriteInt(set, "ReserveCounter", 25);
					}
					else {//if there is one for another tech, decrease the counter: if it is still higher than 0 and needed tech is not an arena unit then stop here
						int rc;
						rc = EnvReadInt(set, "ReserveCounter");
						if (rc > 0) {
							rc -= 1;
							EnvWriteInt(set, "ReserveCounter", rc);
							if (rc <= 0) {
								set.StopReserving();
								EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
							}
							else if (!bArenaHire)
								return;
						}
					}
				else if (!bArenaHire) {//if there is none, reserve for the needed tech unless it is an arena unit
					int nTechReserve;
					nTechReserve = AIVar(AIPlayer, AIV_TechReserve);
					if (nTechReserve > 0)
						if (gold >= nTechReserve)
							if (set.ReserveFor(strTech, AIVar(AIPlayer, AIV_TechBudget))) {
								bReserving = true;
								EnvWriteInt(set, "ReserveCounter", 25);
							}
				}
			}

			if (!bArenaHire)
				if (bPossibleDiscard)
					if (set.gold < AIVar(AIPlayer, AIV_ExcessGold) || rand(10) == 0)
						if (!set.CheckTechBudget(strTech, AIVar(AIPlayer, AIV_TechBudget)))
							return;

			if (!set.CanAfford(strTech)) {
				EnvWriteInt(set, "FreezeArmyBuild", 5);
				return;
			}

			if (bArenaHire)
				set.SpentGoldOnArmy(gold + food / 2);
			else
				set.SpentGoldOnTech(gold + food / 2);

			EnvWriteInt(set, "FreezeArmyBuild", 0);

			if (bReserving) {
				set.StopReserving();
				EnvWriteString(set, "ReserveFor" + (AIPlayer - 1), "");
				EnvWriteInt(set, "ReserveCounter", 0);
			}

			set.Research(strTech);

			//to avoid too much focus on researches instead of army, set a timer for the next tech (excluding arena units) which depends on remaining gold and game bonuses
			if (!bArenaHire) {
				int t;
				if (set.gold >= 4000)
					t = 10000;
				else if (set.gold >= 3000)
					t = 30000;
				else if (set.gold >= 2000)
					t = 60000;
				else if (set.gold >= 1000)
					t = 120000;
				else
					t = 180000;
				if (EnvReadString(set, "StartingBonusP" + AIPlayer) == "BonusGold20")
					t = t * 2 / 3;
				else if (EnvReadString(set, "StartingBonusP" + AIPlayer) == "BonusGold50")
					t = t / 3;
				EnvWriteInt(set, "ResearchTechTime", GetTime() + rand(30001) + t);
			}
			else if (strTech == "Call Valkyries")
				EnvWriteInt(set, "TimeToAvoidExcessTroops", GetTime() + 4000);//add a delay to the next command (see above)
			else if (strTech == "Hire Liberati")
				EnvWriteInt(set, "TimeToAvoidExcessTroops", GetTime() + 4000);//add a delay to the next command (see above)
		}
	}
}