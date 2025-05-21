Building b;
Unit u;
point p;
int i;

b = NO_Town1.obj.AsBuilding();
p = b.pos;
p.Set(p.x, p.y - 150);

b.Research("Charm of Athena");
b.Research("Charm of Aegle");

for (i = 0; i < 10; i += 1) {
	u = Place("HChariot", p, 1).AsUnit();
	u.SetLevel(10);
	u.SetFeeding(false);
	u.AddItem("Charm of Athena");
	u.AddItem("Charm of Aegle");
	b.settlement.ForceAddUnit(u);
}