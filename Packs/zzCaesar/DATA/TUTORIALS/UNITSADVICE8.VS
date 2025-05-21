//void, int playerid

//this script shows a hint about capturing caravans

ObjList ol_selected;

while (1) {
	Sleep(2500);

	ol_selected = _GetSelection().ObjClass(cWagon);
	if (ol_selected.count > 0) {
		ol_selected = ol_selected.ObjEnemy(playerid);
		if (ol_selected.count > 0) {
			ShowHint(
				Translate("Capturing caravans"),
				Translate("To capture a caravan, select some warriors and right-click on it. To successfully perform the capturing process, however, it is necessary that your troops are more than the defenders of the caravan. As time passes, the loyalty of the caravan will slowly decrease and when it falls to 0 the caravan will be yours to control. You can also instantly capture allied caravans by ordering one single warrior to do so."),
				ol_selected[0]
			);
			return;
		}
	}
}