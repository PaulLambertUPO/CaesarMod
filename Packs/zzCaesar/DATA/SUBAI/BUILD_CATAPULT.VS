//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

ObjList builders;
Obj bldr, cat;
Unit u;
IntArray race_nums;
int i, r, race, max;

objs.ClearDead();
builders = objs.FilterClosest(pt, GetConst("CatapultMaxUnits"));

max = -1;

//remove non-military units to prevent some bugs
for (i = builders.count - 1; i >= 0; i -= 1) {
	bldr = builders[i];
	if (!bldr.IsHeirOf("Military"))
		builders.Remove(bldr);
	else if (bldr.IsHeirOf("ShipBattle"))
		builders.Remove(bldr);
	else if (bldr.IsHeirOf("Hero"))
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

//catapult race depends on amount and distance of the selected units
if (builders.count > 0)
	cat = PlaceCatapult(pt.x, pt.y, builders[0].player, race);

for (i = 0; i < builders.count; i += 1) {
	u = builders[i].AsUnit();
	u.SetCommand("build_catapult", cat);
	u.Deselect();
}