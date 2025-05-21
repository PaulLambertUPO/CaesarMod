//void, Settlement set

int idPlayer, playerRace, needs, ships;
str cmd;

idPlayer = set.player;

playerRace = GetPlayerRace(idPlayer);
if (playerRace == RepublicanRome)
	cmd = "buildshipRome";
else if (playerRace == Egypt)
	cmd = "buildshipEgypt";
else
	cmd = "buildship";

while (set.player == idPlayer) {
	if (set.gold >= 100 || set.food >= 100) {
		Settlement dest;
		dest = set.BestToSupply();
		if (dest.IsValid) {
			Wagon wagon;
			if (set.gold >= 100) {
				wagon = set.CreateMuleGold(set.gold);
				if (wagon.IsValid) {
					wagon.AddCommand(false, "unload", dest.GetCentralBuilding());
					wagon.KillCommand();
				}
			}
			if (set.food >= 100) {
				wagon = set.CreateMuleFood(set.food);
				if (wagon.IsValid) {
					wagon.AddCommand(false, "unload", dest.GetCentralBuilding());
					wagon.KillCommand();
				}
			}
		}
	}
	needs = ShipNeeds(idPlayer, set.WaterLsa);
	ships = Ships(idPlayer, set.WaterLsa);
	if (needs > ships)
		if (needs - ships >= 100)
			if (set.CanResearch(cmd)) {
				if (!set.CanAfford(cmd)) {//cheating
					int gold, food;
					GetCmdCost(cmd, gold, food);
					if (set.gold < gold)
						set.SetGold(gold);
					if (set.food < food)
						set.SetFood(food);
					set.SpentGoldOnArmy(gold + food / 2);
				}
				set.Research(cmd);
				ClrShipNeeds(idPlayer, set.WaterLsa);
			}
	Sleep(AIVar(idPlayer, AIV_Sleep_ES));
}