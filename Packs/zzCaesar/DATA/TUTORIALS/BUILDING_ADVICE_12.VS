//void, int playerid

//this script shows a hint about caves (teleports)

ObjList teleports;
Obj o;
int i;

Sleep(50000);

GetSettlements(cTeleport, 0);

while (true) {
	Sleep(30000);
	for (i = teleports.count - 1; i >= 0; i -= 1) {
		o = teleports[i];
		if (IsExplored(o.pos, playerid)) {
			ShowTutorial(
				Translate("Caves"),
				Translate("Caves are underground passages that connect two distant places. You can use them to either surprise the enemy with a rear attack or avoid geographical obstacles."),
				o
			);
			return;
		}
	}
}