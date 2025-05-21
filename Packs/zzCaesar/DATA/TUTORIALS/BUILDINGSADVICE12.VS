//void, int playerid

//this script shows a hint about caves (teleports)

ObjList teleports;
Obj obj;
int i;

Sleep(50000);

teleports = ClassPlayerObjs(cTeleport, 15).GetObjList();

while (1) {
	Sleep(30000);
	for (i = 0; i < teleports.count; i += 1) {
		obj = teleports[i];
		if (IsExplored(obj.pos, playerid)) {
			ShowHint(
				Translate("Caves"),
				Translate("Caves are underground passages that connect two distant places. You can use them to either surprise the enemy with a rear attack or avoid geographical obstacles."),
				obj
			);
			return;
		}
	}
}