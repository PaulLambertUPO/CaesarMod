//void, Obj This

Barrack this;
Settlement set;
Unit new_unit;
point exit_point;
int player, level = 1;
str class, s;

this = This.AsBarrack();

set = .settlement;

player = .player;

class = ParseStr(cmdparam, s);

.Progress(.cmddelay * (1000 - EnvReadInt(set, "BarrackTrainTimeDecrease")) / 1000);

exit_point = .GetExitPoint(set.GetCentralBuilding().pos, false);
if (exit_point.x == -1 && exit_point.y == -1) {
	new_unit = Place(class, Point(0, 0), player);
	set.AddUnit(new_unit);
}
else {
	new_unit = Place(class, exit_point, player);
	new_unit.SetCommand("advanceenter", set.GetCentralBuilding());
}

//Carthage arena upgrades
if (GetClassRace(class) == Carthage)
	if (!new_unit.IsHeirOf("BaseMage")) {
		if (IsResearched(set, "Shared Strength"))
			if (Count(player, class) > 10)
				level = 6;
		if (IsResearched(set, "Shared Triumph"))
			if (Count(player, class) > 20)
				level = 12;
	}

//blacksmith and arena upgrades
level = MAX(level, EnvReadInt(set, "levels/" + class));

//standardization (Imperial Rome)
if (!new_unit.IsHeirOf("BaseMage"))
	level = MAX(level, EnvReadInt(player, "standard_spawn_level"));

//Olympic Games (Greece)
if (level < 5)
	if (!new_unit.IsHeirOf("BaseMage"))
		if (IsResearched(set, "Olympic Games"))
			level = 5;

//Tame horses (Iberia)
if (level < 6)
	if (new_unit.IsHeirOf("ICavalry"))
		if (IsResearched(player, "Tame horses"))
			level = 6;

new_unit.SetLevel(level);

//give items based on respective upgrades
if (!new_unit.IsHeirOf("BaseMage")) {
	if (EnvReadInt(set, "items/Bear teeth amulet") == 1)
		new_unit.AddItem("Bear teeth amulet");
	if (EnvReadInt(set, "items/Belt of might") == 1)
		new_unit.AddItem("Belt of might");
	if (EnvReadInt(set, "items/Herb amulet of luck") == 1)
		new_unit.AddItem("Herb amulet of luck");
	if (EnvReadInt(set, "items/God's Gift") == 1)
		new_unit.AddItem("God's Gift");
	if (EnvReadInt(set, "items/Veteran Guild") == 1)
		new_unit.AddItem("Veteran Guild");
}