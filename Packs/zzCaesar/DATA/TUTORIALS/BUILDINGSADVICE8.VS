//void, int playerid

//this script shows a hint about item holders and wells

ObjList item_holders;
Obj obj;
int i;

Sleep(90000);

item_holders = ClassPlayerObjs(cItemHolder, 15).GetObjList();

while (1) {
	Sleep(30000);
	for (i = 0; i < item_holders.count; i += 1) {
		obj = item_holders[i];
		if (IsExplored(obj.pos, playerid)) {
			ShowHint(
				Translate("Places of interest"),
				Translate("Throughout the map there are a number of locations with item holders that provide minor items or heal units located nearby. Almost all item holders are marked by a circle of small stones around them. To get an item, select a unit then right-click on the item holder."),
				obj
			);
			return;
		}
	}
}