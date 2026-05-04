//void, int playerid

//this script shows a hint about trade routes and supplying

ObjList player_villages, idle_villages;
Obj o;
int i;

Sleep(90000);

while (true) {
	Sleep(60000);
	player_villages = GetSettlements(cBaseVillage, playerid);
	for (i = player_villages.count - 1; i >= 0; i -= 1) {
		o = player_villages[i];
		if (!o.AsBuilding().settlement.supplied.IsValid) {
			if (idle_villages.Contains(o)) {//show hint only from the second time a village is found without a supplied target
				ShowHint(
					Translate("Supply routes"),
					Translate("You can order your settlements (villages, outposts and shipyards) to automatically send the resources that they produce to another settlement by selecting the main building and right-clicking on the chosen destination. After that, a caravan begins transporting resources from one place to another if the amount of said resources is at least 100. Remember to protect your caravans to avoid losing precious resources!"),
					o
				);
				return;
			}
			idle_villages.Add(o);
		}
	}
}