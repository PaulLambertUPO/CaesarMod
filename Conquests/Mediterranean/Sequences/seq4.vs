Building b;
Unit u;
point p;
int i;

b = NO_Town1.obj.AsBuilding();
p = b.pos;
p.Set(p.x, p.y - 150);

b.Research("Battle tactics");

for (i = 0; i < 4; i += 1) {
	u = Place("GTridentWarrior", p, 1).AsUnit();
	u.SetLevel(18);
	u.SetFeeding(false);
	u.AddItem("Bear teeth amulet");
	u.AddItem("Belt of might");
	u.AddItem("Herb amulet of luck");
	b.settlement.ForceAddUnit(u);
}