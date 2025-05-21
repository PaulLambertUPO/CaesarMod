Building b;
Unit u;
point p;
int i;

b = NO_Town1.obj.AsBuilding();
p = b.pos;
p.Set(p.x, p.y - 150);

b.Research("Mahout Mastery");
b.Research("Spoils of war");

for (i = 0; i < 4; i += 1) {
	u = Place("CWarElephant", p, 1).AsUnit();
	u.SetLevel(20);
	u.SetFeeding(false);
	b.settlement.ForceAddUnit(u);
}