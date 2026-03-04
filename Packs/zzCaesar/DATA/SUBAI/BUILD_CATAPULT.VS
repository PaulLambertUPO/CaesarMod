//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

ObjList builders;
Obj bldr;
Catapult catap;
IntArray race_nums;
int i, r, race, max;

builders = objs.FilterClosest(pt, 10);

max = -1;

for (i = builders.count - 1; i >= 0; i -= 1) {
	bldr = builders[i];
	if (bldr.IsDead)
		builders.Remove(bldr);
	else {
		r = bldr.race;
		race_nums[r] += 1;
		if (max < race_nums[r]) {
			race = r;
			max = race_nums[r];
		}
	}
}

if (builders.count > 0)
	catap = PlaceCatapult(pt.x, pt.y, builders[0].player, race);

for (i = builders.count - 1; i >= 0; i -= 1) {
	bldr = builders[i];
	bldr.SetCommand("build_catapult", catap);
	bldr.Deselect();
}