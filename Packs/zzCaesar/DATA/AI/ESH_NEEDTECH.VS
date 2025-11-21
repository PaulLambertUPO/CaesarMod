//void, Settlement set

str strTech;

strTech = EnvReadString(set, "strTech");

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
		int aiPlayer, gold, food;
		bool bPossibleDiscard = false;

		aiPlayer = set.player;

		if (strTech == "Sacred Legion") {
			if (!IsResearched(aiPlayer, "Dark Rituals"))
				strTech = "Dark Rituals";
		}
		else if (strTech == "More Housing") {
			if (!IsResearched(set, "Housing"))
				strTech = "Housing";
		}
		else if (strTech == "Strengthen Stronghold Defences II") {
			if (!IsResearched(set, "Strengthen Stronghold Defences I"))
				strTech = "Strengthen Stronghold Defences I";
		}
		else if (strTech == "Gaul Iron Axes") {
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
		else if (strTech == "Gaul Fine Armor") {
			if (!IsResearched(set, "Gaul Woman Warrior"))
				strTech = "Gaul Woman Warrior";
		}
		else if (strTech == "Improve Praetorian Equipment")
			if (!IsResearched(set, "Roman Praetorian"))
				strTech = "Roman Praetorian";

		if (IsResearched(set, strTech))
			bPossibleDiscard = true;
		else if (IsResearched(aiPlayer, strTech))
			bPossibleDiscard = true;
		else if (IsResearching(set, strTech))
			bPossibleDiscard = true;
		else if (IsResearching(aiPlayer, strTech))
			bPossibleDiscard = true;
		else if (!GetCmdCost(strTech, gold, food))
			bPossibleDiscard = true;

		if (bPossibleDiscard) {
			if (EnvReadString(set, "ReserveFor" + (aiPlayer - 1)) == strTech) {
				set.StopReserving();
				EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
			}
			EnvWriteInt(set, "FreezeArmyBuild", 0);
			return;
		}

		if (set.CanResearch(strTech)) {
			str strReserving;
			bool bReserving = false;

			//if there is a huge amount of needed resources in the stronghold, there is no reason to discard the research
			if (gold > 0)
				if (set.gold < AIVar(aiPlayer, AIV_SquanderGoldAmount))
					bPossibleDiscard = true;
			if (!bPossibleDiscard)
				if (food > 0)
					if (set.food < AIVar(aiPlayer, AIV_SquanderFoodAmount))
						bPossibleDiscard = true;

			strReserving = EnvReadString(set, "ReserveFor" + (aiPlayer - 1));
			if (strReserving == strTech)
				bReserving = true;

			//if possible to discard, check reservation
			if (bPossibleDiscard)
				if (strReserving != "") {
					if (bReserving)//if there is a reservation for the needed tech, refresh the counter
						EnvWriteInt(set, "ReserveCounter", 25);
					else {//if reserving for another tech, decrease counter: if still higher than 0 and needed tech is not an arena unit, stop here
						int rc;
						rc = EnvReadInt(set, "ReserveCounter");
						if (rc > 0) {
							rc -= 1;
							EnvWriteInt(set, "ReserveCounter", rc);
							if (rc <= 0) {
								set.StopReserving();
								EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
							}
							else if (!bArenaHire)
								return;
						}
					}
				}
				else if (!bArenaHire) {//if there is no reservation, reserve for the needed tech unless it is an arena unit
					int nTechReserve;
					nTechReserve = AIVar(aiPlayer, AIV_TechReserve);
					if (nTechReserve > 0)
						if (gold >= nTechReserve)
							if (set.ReserveFor(strTech, AIVar(aiPlayer, AIV_TechBudget))) {
								bReserving = true;
								EnvWriteInt(set, "ReserveCounter", 25);
							}
				}

			if (bPossibleDiscard)
				if (!bArenaHire)
					if (!set.CheckTechBudget(strTech, AIVar(aiPlayer, AIV_TechBudget))) {
						if (rand(10) == 0)
							return;
						if (gold > 0)
							if (set.gold < AIVar(aiPlayer, AIV_ExcessGold))
								return;
					}

			if (set.CanAfford(strTech)) {
				if (bArenaHire)
					set.SpentGoldOnArmy(gold + food / 2);
				else
					set.SpentGoldOnTech(gold + food / 2);

				EnvWriteInt(set, "FreezeArmyBuild", 0);

				if (bReserving) {//remove the reservation for the needed tech
					set.StopReserving();
					EnvWriteString(set, "ReserveFor" + (aiPlayer - 1), "");
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
					if (EnvReadString(set, "StartingBonusP" + aiPlayer) == "BonusGold20")
						t = t * 2 / 3;
					else if (EnvReadString(set, "StartingBonusP" + aiPlayer) == "BonusGold50")
						t = t / 3;
					EnvWriteInt(set, "ResearchTechTime", GetTime() + rand(30001) + t);
				}
			}
			else
				EnvWriteInt(set, "FreezeArmyBuild", 5);
		}
	}
}