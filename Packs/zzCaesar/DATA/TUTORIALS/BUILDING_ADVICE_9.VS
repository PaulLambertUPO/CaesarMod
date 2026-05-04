//void, int playerid

//this script shows a hint about Teuton tents

ObjList tents;
Obj o;
int i;

Sleep(25000);

tents = GetSettlements(cTTent, 15);

while (true) {
	Sleep(15000);
	for (i = tents.count - 1; i >= 0; i -= 1) {
		o = tents[i];
		if (IsExplored(o.pos, playerid)) {
			ShowHint(
				Translate("Teuton and Numidian camps"),
				Translate("Teuton and Numidian camps are neutral and will attack anyone who gets too close. If you are strong enough to vanquish the guards of a camp, it will become yours to command and provide you with some units. If you bring food to the camp, you can spend it to produce a unit of choice over time."),
				o
			);
			return;
		}
	}
}