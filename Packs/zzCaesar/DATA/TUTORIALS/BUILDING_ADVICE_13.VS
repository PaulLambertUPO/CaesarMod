//void, int playerid

//this script shows a hint about stonehenges

ObjList stonehenges;
Obj o;
int i;

Sleep(30000);

GetSettlements(cStonehenge, 0);

while (true) {
	Sleep(30000);
	for (i = stonehenges.count - 1; i >= 0; i -= 1) {
		o = stonehenges[i];
		if (IsExplored(o.pos, playerid)) {
			ShowHint(
				Translate("Stonehenges"),
				Translate("Stonehenges are special places that allow you to cast powerful spells which have effect all over the map for all players. Every spell requires a specific amount of energy that can be accumulated by placing mages nearby: the more they are, the faster the energy accumulation will be."),
				o
			);
			return;
		}
	}
}