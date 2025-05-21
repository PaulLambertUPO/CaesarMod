//void, int playerid

//this script shows a hint about Teuton tents

ObjList tents;
Obj obj;
int i;

Sleep(25000);

tents = ClassPlayerObjs(cTTent, 15).GetObjList();

while (1) {
	Sleep(15000);
	for (i = 0; i < tents.count; i += 1) {
		obj = tents[i];
		if (IsExplored(obj.pos, playerid)) {
			ShowHint(
				Translate("Teuton and Numidian camps"),
				Translate("Teuton and Numidian camps are neutral and will attack anyone who gets too close. If you are strong enough to vanquish the guards of a camp, it will become yours to command and provide you with some units. If you bring food to the camp, you can spend it to produce a unit of your choice over time."),
				obj
			);
			return;
		}
	}
}