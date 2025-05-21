//void, Obj This

Barrack this;
Settlement set;
Unit new_unit;
point exit_point;
int player, level;

this = This.AsBuilding();
set = .settlement;
player = .player;

while (set.IsFull())
	Sleep(500);
.Progress();
while (set.IsFull())
	Sleep(500);

level = EnvReadInt(set, "levels/Hero");

if (IsResearched(player, "Mumification")) {
	ObjList ol;
	Hero h;
	int i;

	level = EnvReadInt(player, "BestHeroLevel");
	ol = GetPlayerUnits(player, "Hero");
	for (i = 0; i < ol.count; i += 1) {
		h = ol[i].AsHero();
		if (h.IsValid)
			if (h.inherentlevel > level)
				level = h.inherentlevel;
	}
	level = MAX(1, level * 2 / 3);
}

exit_point = .GetExitPoint(set.GetCentralBuilding().pos, false);
if (exit_point.x == -1 && exit_point.y == -1) {
	new_unit = Place(GetRandomHeroClass(cmdparam, player), Point(0, 0), player);
	set.AddUnit(new_unit);
}
else {
	new_unit = Place(GetRandomHeroClass(cmdparam, player), exit_point, player);
	new_unit.SetCommand("advanceenter", set.GetCentralBuilding());
}
new_unit.SetLevel(level);