//void, int playerid

//this script shows a hint about trade routes and supplying

ObjList player_villages, unattached_villages;
Obj obj;
int i;

Sleep(90000);

while (1) {
	Sleep(60000);
	player_villages = ClassPlayerObjs(cBaseVillage, playerid).GetObjList();
	for (i = 0; i < player_villages.count; i += 1) {
		obj = player_villages[i];
		if (!obj.AsBuilding().settlement.supplied.IsValid())
			if (unattached_villages.Contains(obj)) {//show hint only from the second time a village is found without a supplied target
				ShowHint(
					Translate("Supply routes"),
					Translate("You can order your settlements (villages, outposts and shipyards) to automatically send the resources that they produce to another settlement by selecting the main building and right-clicking on the chosen destination. After that, a caravan begins transporting resources from one place to another if the amount of said resources is at least 100. Remember to protect your caravans to avoid losing precious resources!"),
					obj
				);
				return;
			}
			else
				unattached_villages.Add(obj);
	}
}