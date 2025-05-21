//void, Obj This

Building this;
Settlement set;
int timer;

this = This.AsBuilding();
set = .settlement;

while (1) {
	timer = EnvReadInt(set, "ApolloProtectionTimer");

	if (timer > 0) {
		ObjList gates;
		str zero_sec_marker;
		int i, secs;

		gates = set.ObjectsAround("Gate");
		for (i = 0; i < gates.count; i += 1)
			gates[i].SetHealth(gates[i].maxhealth);

		secs = timer % 60;
		if (secs < 10)
			zero_sec_marker = "0";

		ShowAnnouncement("ApolloProtectionS" + set.GetGaika().ID, Translatef("Player %s1 - protected for %s2", .player, timer / 60 + ":" + zero_sec_marker + secs));

		EnvWriteInt(set, "ApolloProtectionTimer", timer - 1);
	}
	else
		HideAnnouncement("ApolloProtectionS" + set.GetGaika().ID);

	Sleep(1000);
}