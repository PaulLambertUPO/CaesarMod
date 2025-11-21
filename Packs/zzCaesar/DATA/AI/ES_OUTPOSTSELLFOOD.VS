//void, Settlement set

int aiPlayer;
Settlement supplied;

aiPlayer = set.player;

while (set.player == aiPlayer) {
	supplied = set.supplied;
	if (!supplied.IsValid)
		break;
	if (supplied.player != aiPlayer)
		break;
	if (EnvReadString(set, "GOutpostSellFood") != "yes") {//start selling food
		EnvWriteString(set, "GOutpostSellFood", "yes");
		EnvWriteString(set, "GOutpostSellGold", "no");
	}
	if (set.gold >= 100) {//send produced gold
		Wagon mule;
		mule = set.CreateMuleGold(set.gold);
		if (mule.IsValid)
			mule.SetCommand("unload", supplied.GetCentralBuilding());
	}
	Sleep(2000);
}