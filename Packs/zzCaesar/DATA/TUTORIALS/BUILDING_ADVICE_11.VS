//void, int playerid

//this script shows a hint about ruins

ObjList ruins;
Obj o;
int i;

Sleep(60000);

ruins = GetSettlements(cBaseRuins, 0);

while (true) {
	Sleep(30000);
	for (i = ruins.count - 1; i >= 0; i -= 1) {
		o = ruins[i];
		if (IsExplored(o.pos, playerid)) {
			ShowTutorial(
				Translate("Ruins"),
				Translate("Ruins are places where heroes can gather powerful items that will aid them in battle. In order to acquire an item, the hero must be of the specified level (displayed when the ruins are selected). Upon exiting the ruins, the hero's health is always 20% of the maximum."),
				o
			);
			return;
		}
	}
}