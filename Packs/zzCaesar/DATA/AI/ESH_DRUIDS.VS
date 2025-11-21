//void, Settlement set

int aiPlayer;

aiPlayer = set.player;

if (Count(aiPlayer, "BaseMage") < AIVar(aiPlayer, AIV_Mages) * MilUnits(aiPlayer) / 100) {//available < needed
	int nRace;
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
	else if (nRace == Egypt)
		cmd = "trainEPriest";
	else if (nRace == Germany)
		cmd = "trainTEnchantress";
	else//Greece
		cmd = "trainHPriest";

	if (set.CanResearch(cmd))
		if (set.CanAfford(cmd)) {
			int gold, food;
			if (GetCmdCost(cmd, gold, food)) {
				set.SpentGoldOnArmy(gold + food / 2);
				set.Research(cmd);
			}
		}
}