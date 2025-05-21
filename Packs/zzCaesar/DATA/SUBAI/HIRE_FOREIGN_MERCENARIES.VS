//void, Obj this

Settlement set;
Unit u;
point pt;
int i, p;

.Progress();

set = .AsBuilding().settlement;
pt = .pos;
p = .player;

for (i = 0; i < 10; i += 1) {
	u = Place("MercenaryGHorseman", pt, p);
	set.ForceAddUnit(u);
}
for (i = 0; i < 20; i += 1) {
	u = Place("MercenaryHHoplite", pt, p);
	set.ForceAddUnit(u);
}
for (i = 0; i < 20; i += 1) {
	u = Place("MercenaryISlinger", pt, p);
	set.ForceAddUnit(u);
}