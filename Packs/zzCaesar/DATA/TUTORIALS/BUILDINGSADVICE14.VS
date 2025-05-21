//void, int playerid

//this script shows a hint about stonehenges

ObjList stonehenges;
Obj obj;
int i;

Sleep(30000);

stonehenges = ClassPlayerObjs(cStonehenge, 15).GetObjList();

while (1) {
	Sleep(30000);
	for (i = 0; i < stonehenges.count; i += 1) {
		obj = stonehenges[i];
		if (IsExplored(obj.pos, playerid)) {
			ShowHint(
				Translate("Stonehenges"),
				Translate("Stonehenges are special places that allow you to cast powerful spells which have effect all over the map for all players. Every spell requires a specific amount of energy that can be accumulated by placing mages nearby: the more they are, the faster the energy accumulation will be."),
				obj
			);
			return;
		}
	}
}