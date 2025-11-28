//void, Settlement set

int aiPlayer, waterLsa, nSleepES;
str cmd = "buildship";

aiPlayer = set.player;
waterLsa = set.WaterLsa;
nSleepES = AIVar(aiPlayer, AIV_Sleep_ES);

{
	int playerRace;
	playerRace = GetPlayerRace(aiPlayer);
	if (playerRace == RepublicanRome)
		cmd = "buildshipRome";
	else if (playerRace == Egypt)
		cmd = "buildshipEgypt";
}

while (set.player == aiPlayer) {
	if (set.gold >= 100 || set.food >= 100) {
		Settlement stronghold;
		stronghold = set.BestToSupply;//it returns the nearest owned stronghold
		if (stronghold.IsValid) {
			Wagon mule;
			if (set.gold >= 100) {
				mule = set.CreateMuleGold(set.gold);
				if (mule.IsValid)
					mule.SetCommand("unload", stronghold.GetCentralBuilding());
			}
			if (set.food >= 100) {
				mule = set.CreateMuleFood(set.food);
				if (mule.IsValid)
					mule.SetCommand("unload", stronghold.GetCentralBuilding());
			}
		}
	}
	if (ShipNeeds(aiPlayer, waterLsa) - Ships(aiPlayer, waterLsa) >= 100)
		if (set.CanResearch(cmd)) {
			int gold, food;
			if (GetCmdCost(cmd, gold, food)) {//save the original command costs, but use the cheating one
				set.SpentGoldOnArmy(gold + food / 2);
				set.Research(cmd + "Ai");
				ClrShipNeeds(aiPlayer, waterLsa);
			}
		}
	Sleep(nSleepES);
}