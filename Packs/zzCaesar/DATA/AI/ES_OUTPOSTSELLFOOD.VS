//void, Settlement set

int idPlayer;
idPlayer = set.player;
while (set.supplied.player == idPlayer) {
	if (EnvReadString(set, "GOutpostSellFood") != "yes") {//start selling food
		EnvWriteString(set, "GOutpostSellFood", "yes");
		EnvWriteString(set, "GOutpostSellGold", "no");
		Sleep(100);
		continue;
	}
	if (set.gold >= 100) {//send only gold
		Wagon wagon;
		wagon = set.CreateMuleGold(set.gold);
		if (wagon.IsValid) {
			wagon.AddCommand(false, "unload", set.supplied.GetCentralBuilding());
			wagon.KillCommand();
		}
	}
	Sleep(2000);
}