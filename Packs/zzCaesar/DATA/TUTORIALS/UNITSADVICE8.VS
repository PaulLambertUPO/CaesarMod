//void, int playerid

//this script shows a hint about capturing caravans

ObjList ol_selected_enemy_wagons;

while (1) {
	Sleep(2500);
	ol_selected_enemy_wagons = _GetSelection().ObjClass(cWagon).ObjEnemy(playerid);
	if (ol_selected_enemy_wagons.count > 0) {
		ShowHint(
			Translate("Capturing caravans"),
			Translate("To capture a caravan, select some warriors and right-click on it. To successfully perform the capturing process, however, it is necessary that your troops are more than the defenders of the caravan. As time passes, the loyalty of the caravan will slowly decrease and when it falls to 0 the caravan will be yours to control. You can also instantly capture allied caravans by ordering one single warrior to do so."),
			ol_selected_enemy_wagons[rand(ol_selected_enemy_wagons.count)]
		);
		return;
	}
}