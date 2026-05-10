//void, Settlement set

int aiPlayer, waterLsa, nSleepES;
str cmd;

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
	else
		cmd = "buildship";
}

while (set.player == aiPlayer) {
	if (set.gold >= 100 || set.food >= 100) {
		Settlement stronghold;
		stronghold = set.BestToSupply;//it returns the nearest owned stronghold
		if (stronghold.IsValid) {
			if (set.gold >= 100)
				set.CreateMuleGold(set.gold).SetCommand("unload", stronghold.GetCentralBuilding());
			if (set.food >= 100)
				set.CreateMuleFood(set.food).SetCommand("unload", stronghold.GetCentralBuilding());
		}
	}

	if (rand(200) == 0)//extremely low chance because the AI player can have many shipyards
		IncShipNeeds(aiPlayer, waterLsa);

	if (ShipNeeds(aiPlayer, waterLsa) - Ships(aiPlayer, waterLsa) >= 50)
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