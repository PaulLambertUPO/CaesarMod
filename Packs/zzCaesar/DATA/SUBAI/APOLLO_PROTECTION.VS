//void, int player

ObjList strongholds, buildings;
Building b;
str announcement;
int i, j, timer = 120;

strongholds = GetSettlements("BaseTownhall", 0);

announcement = "ApolloProtectionP" + player;

while (timer > 0) {
	i = timer % 60;
	if (i < 10)
		ShowAnnouncement(announcement, Translatef("Player %s1 - protected for %s2:0%s3", player, timer / 60, i));
	else
		ShowAnnouncement(announcement, Translatef("Player %s1 - protected for %s2:%s3", player, timer / 60, i));

	for (i = strongholds.count - 1; i >= 0; i -= 1) {
		b = strongholds[i].AsBuilding();
		if (b.player == player) {
			buildings = b.settlement.Buildings;
			for (j = buildings.count - 1; j >= 0; j -= 1) {
				b = buildings[j].AsBuilding();
				if (b.IsBroken)
					b.RRepair();
				b.SetHealth(b.maxhealth);
			}
		}
	}

	timer -= 1;
	Sleep(1000);
}

HideAnnouncement(announcement);