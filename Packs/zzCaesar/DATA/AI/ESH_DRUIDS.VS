//void, Settlement set

int AIPlayer;

AIPlayer = set.player;

if (Count(AIPlayer, "BaseMage") < AIVar(AIPlayer, AIV_Mages) * MilUnits(AIPlayer) / 100) {//available < needed
	int nRace, gold, food;
	str cmd;

	nRace = set.GetCentralBuilding().race;

	if (nRace == Gaul)
		cmd = "trainGDruid";
	else if (nRace == RepublicanRome) {
		if (IsResearched(set, "ChoosePunicRome"))
			cmd = "trainRPriestPunic";
		else
			cmd = "trainRPriest";
	}
	else if (nRace == Carthage)
		cmd = "trainCShaman";
	else if (nRace == Iberia)
		cmd = "trainIEnchantress";
	else if (nRace == Britain)
		cmd = "trainBDruid";
	else if (nRace == Germany)
		cmd = "trainTEnchantress";
	else if (nRace == Egypt)
		cmd = "trainEPriest";
	else
		cmd = "trainHPriest";

	if (GetCmdCost(cmd, gold, food))
		if (set.CanResearch(cmd))
			if (set.CanAfford(cmd)) {
				set.SpentGoldOnArmy(gold + food / 2);
				set.Research(cmd);
			}
}