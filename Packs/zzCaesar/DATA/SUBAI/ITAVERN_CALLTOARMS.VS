//void, Obj this

Settlement set;
Unit u;
bool veteran_upgrade;
point pt;
int i, p, level;

.Progress();

set = .AsBuilding().settlement;
pt = .pos;
p = .player;

veteran_upgrade = EnvReadInt(set, "items/Veteran Guild") == 1;

if (GetTime() >= 600000)
	level = 8;
else
	level = 4;

for (i = 0; i < 50; i += 1) {
	u = Place("IMilitiaman", pt, p);
	u.SetLevel(level);
	if (veteran_upgrade)
		u.AddItem("Veteran Guild");
	set.ForceAddUnit(u);
}