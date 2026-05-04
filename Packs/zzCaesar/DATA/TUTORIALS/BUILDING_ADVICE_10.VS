//void, int playerid

//this script shows a hint about item holders and wells

ObjList item_holders;
Obj o;
int i;

Sleep(90000);

for (i = 1; i <= 16; i += 1)
	item_holders.AddList(ClassPlayerObjs(cItemHolder, i).GetObjList());

while (true) {
	Sleep(30000);
	for (i = 0; i < item_holders.count; i += 1) {
		o = item_holders[i];
		if (IsExplored(o.pos, playerid)) {
			ShowHint(
				Translate("Places of interest"),
				Translate("Throughout the map there are a number of locations with item holders that provide minor items or heal units located nearby. Almost all item holders are marked by a circle of small stones around them. To get an item, select a unit then right-click on the item holder."),
				o
			);
			return;
		}
	}
}