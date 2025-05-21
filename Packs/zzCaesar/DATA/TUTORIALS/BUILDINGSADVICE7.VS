//void, int playerid

//this script shows a hint about ruins

ObjList ruins;
Obj obj;
int i;

Sleep(60000);

ruins = ClassPlayerObjs(cBaseRuins, 15).GetObjList();

while (1) {
	Sleep(30000);
	for (i = 0; i < ruins.count; i += 1) {
		obj = ruins[i];
		if (IsExplored(obj.pos, playerid)) {
			ShowHint(
				Translate("Ruins"),
				Translate("Ruins are places where heroes can gather powerful items that will aid them in battle. In order to acquire an item, the hero must be of the specified level (displayed when the ruins are selected). Upon exiting the ruins, the hero's health is always 20% of the maximum."),
				obj
			);
			return;
		}
	}
}